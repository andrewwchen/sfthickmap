//
//  SFAnnotation.swift
//  sfthickmap
//
//  Created by devstudio on 11/6/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import MapKit
import CoreData
import Foundation
 
/*
class dataAnnotation: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var lat: Double
    @NSManaged var long: Double
    @NSManaged var imgs: [String]
}
*/

struct docAnnotation: Codable {
    let title: String?
    let desc: String?
    let lat: Double
    let long: Double
    let imgs: [String]
}

class SFAnnotation: MKPointAnnotation{

    var desc: String?
    var imgs: [UIImage]
    
    init (desc: String?=nil, imgs: [UIImage]=[]) {
        self.desc = desc
        self.imgs = imgs
    }
    func initFromNSManagedObject(nsManagedObject: NSManagedObject) {
        let title = (nsManagedObject.value(forKey: "title") as! String)
        let desc = (nsManagedObject.value(forKey: "desc") as! String)
        let lat = (nsManagedObject.value(forKey: "lat") as! Double)
        let long = (nsManagedObject.value(forKey: "long") as! Double)
        let imgs = urlDecombiner(combinedString: (nsManagedObject.value(forKey: "imgs") as! String))
        initFromData(title: title, desc: desc, lat: lat, long: long, imgs: imgs)
        
    }
    func initFromCodable(codable: docAnnotation)  {
        initFromData(title: codable.title, desc: codable.desc, lat: codable.lat, long: codable.long, imgs: codable.imgs)
    }
    func initFromData(title: String?, desc: String?, lat: Double, long: Double, imgs: [String]) {
        if title != "" {
            self.title = title
        } else {
            self.title = nil
        }
        if desc != "" {
            self.desc = desc
        } else {
            self.desc = nil
        }
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        for link in imgs {
            if !link.isEmpty{
                checkBookFileExists(withLink: link){ [weak self] downloadedURL in
                    guard let self = self else{
                        return
                    }
                    let urlImg = UIImage(contentsOfFile: downloadedURL.relativePath)
                    if urlImg != nil {
                        self.imgs.append(urlImg!)
                    } else {
                        print("decoding image from URL failed")
                    }
                }
            }
        }

    }
}
