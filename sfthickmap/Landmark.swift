//
//  Landmark.swift
//  sfthickmap
//
//  Created by devstudio on 11/23/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import MapKit
import CoreData
import Foundation

/*
class dataLandmark: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var code: String?
    @NSManaged var img: String
}
 */

struct docLandmark: Codable {
    let title: String?
    let code: String?
    let img: String
    let trigger: String?
}

public class Landmark: NSObject {
    var title: String?
    var code: String?
    var img: UIImage
    var panoButtons: [PanoButton]
    var trigger: CGImage?

    func initFromNSManagedObject(nsManagedObject: NSManagedObject, buttons: [PanoButton]) {
        let title = (nsManagedObject.value(forKey: "title") as! String)
        let code = (nsManagedObject.value(forKey: "code") as! String)
        let img = (nsManagedObject.value(forKey: "img") as! String)
        let trigger = (nsManagedObject.value(forKey: "trigger") as! String)
        initFromData(title: title, code: code, img: img, trigger: trigger, buttons: buttons)
        
    }
    func initFromCodable(codable: docLandmark, buttons: [PanoButton])  {
        initFromData(title: codable.title, code: codable.code, img: codable.img, trigger: codable.trigger, buttons: buttons)
    }
    func initFromData(title: String?, code: String?, img: String, trigger: String?, buttons: [PanoButton]) {
            if title != "" {
                self.title = title
            } else {
                self.title = nil
            }
            if code != "" {
                self.code = code
            } else {
                self.code = nil
            }
        
            let link = img
            checkBookFileExists(withLink: link){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                }
                let urlImg = UIImage(contentsOfFile: downloadedURL.relativePath)
                if urlImg != nil {
                    self.img = urlImg!
                } else {
                    print("decoding image from URL failed")
                    self.img = UIImage(imageLiteralResourceName: "landmark1.jpg")
                }
            }
        
            if trigger != nil {
                checkBookFileExists(withLink: trigger!){ [weak self] downloadedURL in
                    guard let self = self else{
                        return
                    }
                    let urlImg = UIImage(contentsOfFile: downloadedURL.relativePath)?.cgImage
                    if urlImg != nil {
                        self.trigger = urlImg!
                    } else {
                        print("decoding image from URL failed")
                        self.trigger = UIImage(imageLiteralResourceName: "landmark1.jpg").cgImage
                    }
                }
            }
        
            if self.title != nil {
                for b in buttons {
                    if b.landmarks.contains(self.title!) {
                        self.panoButtons.append(b)
                    }
                }
            }

    }

    init (title: String?=nil, code: String?=nil, img: UIImage=UIImage(imageLiteralResourceName: "landmark1.jpg"), trigger: CGImage?=nil, panoButtons: [PanoButton]=[]){
        self.title = title
        self.code = code
        self.img = img
        self.panoButtons = panoButtons
        self.trigger = trigger
    }
}
