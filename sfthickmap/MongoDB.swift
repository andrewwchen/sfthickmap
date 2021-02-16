//
//  MongoDB.swift
//  sfthickmap
//
//  Created by devstudio on 12/16/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import MongoSwift
import StitchCore
import StitchRemoteMongoDBService
import CoreData

var client: StitchAppClient? = nil

var mongoClient: RemoteMongoClient? = nil

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

enum LoginError: Error {
    case clientFailure
}


func getDocs(collNames: [String], completion: @escaping (_ docs: [String: [Document]]?, _ error: Error?) -> Void) {
    print("getting docs")
    if client == nil {
        client = try! Stitch.initializeDefaultAppClient(withClientAppID: "testing-application-fswwb")
    }
    if mongoClient == nil && client != nil{
        mongoClient = try! client!.serviceClient(
                fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas"
        )
    }

    if mongoClient != nil {
        print("MongoDB.swift: Querying")
        
        client!.auth.login(withCredential: AnonymousCredential()) { result in
            switch result {
            case .success( _): // let user
                let group = DispatchGroup()
                var docsDict: [String: [Document]] = [:]
                collNames.forEach { collName in
                    group.enter()
                    let coll = mongoClient!.db("testing-database").collection(collName)
                    coll.find().toArray({ result in
                        switch result {
                        case .success(let result):
                            print("MongoDB.swift: Found documents in collection: \(collName)")
                            docsDict[collName] = result
                            group.leave()
                        case .failure(let error):
                            print("MongoDB.swift: Error in finding documents in collection, \(collName): \(error)")
                            completion(nil, error)
                            group.leave()
                        }
                    })
                }
                group.notify(queue: .main) {
                    completion(docsDict, nil)
                }

            case .failure(let error):
                print("MongoDB.swift: Error in login: \(error)")
                completion(nil, error)
            }
        }
    } else {
        print("MongoDB.swift: Error in finding client or mongoClient")
        completion(nil, LoginError.clientFailure)
    }

}

func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
    let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    if let url  = URL.init(string: urlString ?? ""){
        let fileManager = FileManager.default
        if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){
            let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
            do {
                if try filePath.checkResourceIsReachable() {
                    print("file exist")
                    completion(filePath)

                } else {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            } catch {
                print("file doesnt exist")
                downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
            }
        }else{
            print("file doesnt exist")
        }
    }else{
        print("file doesnt exist")
    }
}


func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
    DispatchQueue.global(qos: .background).async {
        do {
            let data = try Data.init(contentsOf: url)
            try data.write(to: filePath, options: .atomic)
            print("saved at \(filePath.absoluteString)")
            DispatchQueue.main.async {
                completion(filePath)
            }
        } catch {
            print("an error happened while downloading or saving the file")
        }
    }
}

func stringCombiner(strings: [String]) -> String {
    return strings.joined(separator: "*")
}

func stringDecombiner(combinedString: String) -> [String] {
    return combinedString.components(separatedBy: "*")
}

func urlCombiner(strings: [String]) -> String {
    return strings.joined(separator: " ")
}

func urlDecombiner(combinedString: String) -> [String] {
    return combinedString.components(separatedBy: " ")
}

func decodeDocs(docs: [String: [Document]]) -> ([docAnnotation], [docButton], [docLandmark])? {
    do {
        var decodedAnnotations:[docAnnotation] = []
        
        for doc in docs["annotations"]! {
            let decoded = try BSONDecoder().decode(docAnnotation.self, from: doc)
            decodedAnnotations.append(decoded)
        }
        
        var decodedButtons:[docButton] = []
        for doc in docs["buttons"]! {
            let decoded = try BSONDecoder().decode(docButton.self, from: doc)
            decodedButtons.append(decoded)
        }
        
        var decodedLandmarks:[docLandmark] = []
        for doc in docs["landmarks"]! {
            let decoded = try BSONDecoder().decode(docLandmark.self, from: doc)
            decodedLandmarks.append(decoded)
        }
        
        return (decodedAnnotations, decodedButtons, decodedLandmarks)
    } catch {
        print("Failed to decode")
        return nil
    }
}


func contextualizeAndGetData(decodedDocs: ([docAnnotation], [docButton], [docLandmark])) -> ([SFAnnotation], [Landmark]) {
    let docAnnotations = decodedDocs.0
    let docButtons = decodedDocs.1
    let docLandmarks = decodedDocs.2
    
    var newAnnotations: [SFAnnotation] = []
    var newButtons: [PanoButton] = []
    var newLandmarks: [Landmark] = []
    
    let dataAnnotationEntity = NSEntityDescription.entity(forEntityName: "DataAnnotation", in: context)
    let dataButtonEntity = NSEntityDescription.entity(forEntityName: "DataButton", in: context)
    let dataLandmarkEntity = NSEntityDescription.entity(forEntityName: "DataLandmark", in: context)
    
    for d in docAnnotations {
        let dataAnnotation = NSManagedObject(entity: dataAnnotationEntity!, insertInto: context)
        dataAnnotation.setValue(d.title, forKey: "title")
        dataAnnotation.setValue(d.desc, forKey: "desc")
        dataAnnotation.setValue(d.lat, forKey: "lat")
        dataAnnotation.setValue(d.long, forKey: "long")
        dataAnnotation.setValue(urlCombiner(strings: d.imgs), forKey: "imgs")
        let newAnnotation = SFAnnotation()
        newAnnotation.initFromCodable(codable: d)
        newAnnotations.append(newAnnotation)
    }
    for d in docButtons {
        let dataButton = NSManagedObject(entity: dataButtonEntity!, insertInto: context)
        dataButton.setValue(d.title, forKey: "title")
        dataButton.setValue(d.desc, forKey: "desc")
        dataButton.setValue(d.theta, forKey: "theta")
        dataButton.setValue(d.phi, forKey: "phi")
        dataButton.setValue(urlCombiner(strings: d.audios), forKey: "audios")
        dataButton.setValue(urlCombiner(strings: d.imgs), forKey: "imgs")
        dataButton.setValue(stringCombiner(strings: d.landmarks), forKey: "landmarks")
        let newButton = PanoButton()
        newButton.initFromCodable(codable: d)
        newButtons.append(newButton)
    }
    for d in docLandmarks {
        let dataLandmark = NSManagedObject(entity: dataLandmarkEntity!, insertInto: context)
        dataLandmark.setValue(d.title, forKey: "title")
        dataLandmark.setValue(d.code, forKey: "code")
        dataLandmark.setValue(d.img, forKey: "img")
        dataLandmark.setValue(d.trigger, forKey: "trigger")
        let newLandmark = Landmark()
        newLandmark.initFromCodable(codable: d, buttons: newButtons)
        newLandmarks.append(newLandmark)
    }
    
    return (newAnnotations, newLandmarks)
}


func saveData() -> Error? {
    do {
        try context.save()
        return nil
    } catch {
        return error
    }
}


func loadData() -> ([SFAnnotation], [Landmark])? {
    var newAnnotations: [SFAnnotation] = []
    var newButtons: [PanoButton] = []
    var newLandmarks: [Landmark] = []
    
    let annotationRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataAnnotation")
    let buttonRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataButton")
    let landmarkRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataLandmark")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    
    annotationRequest.returnsObjectsAsFaults = false
    buttonRequest.returnsObjectsAsFaults = false
    landmarkRequest.returnsObjectsAsFaults = false
    
    do {
        let result = try context.fetch(annotationRequest)
        for data in result as! [NSManagedObject] {
            let newAnnotation = SFAnnotation()
            newAnnotation.initFromNSManagedObject(nsManagedObject: data)
            newAnnotations.append(newAnnotation)
      }
    } catch {
        print("Error loading annotation data")
        return nil
    }
    do {
        let result = try context.fetch(buttonRequest)
        for data in result as! [NSManagedObject] {
            let newButton = PanoButton()
            newButton.initFromNSManagedObject(nsManagedObject: data)
            newButtons.append(newButton)
      }
    } catch {
        print("Error loading button data")
        return nil
    }
    do {
        let result = try context.fetch(landmarkRequest)
        for data in result as! [NSManagedObject] {
            let newLandmark = Landmark()
            newLandmark.initFromNSManagedObject(nsManagedObject: data, buttons: newButtons)
            newLandmarks.append(newLandmark)
      }
    } catch {
        print("Error loading landmark data")
        return nil
    }
    return (newAnnotations, newLandmarks)
}

