//
//  PanoButton.swift
//  sfthickmap
//
//  Created by devstudio on 11/17/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SceneKit
import CoreData
import Foundation
 
/*
class dataButton: NSManagedObject {
    @NSManaged var landmarks: [String]
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var theta: Double
    @NSManaged var phi: Double
    @NSManaged var audios: [String]
    @NSManaged var imgs: [String]
}
*/

struct docButton: Codable {
    let landmarks: [String]
    let title: String?
    let desc: String?
    let theta: Double
    let phi: Double
    let audios: [String]
    let imgs: [String]
}

public class PanoButton: NSObject {
    var landmarks: [String]
    var title: String?
    var desc: String?
    var vector: SCNVector3
    var audios: [URL]
    var imgs: [UIImage]
    
    var node: SCNNode
    var img: UIImageView
    
    let icon1 = "plus.circle.fill"
    let icon2 = "plus.circle"
    let color = UIColor(ciColor: .white)
    let size = CGFloat(10)
    
    
    func highlight() {
        img.isHighlighted = true
    }
    func unhighlight() {
        img.isHighlighted = false
    }
    func initFromNSManagedObject(nsManagedObject: NSManagedObject) {
        let title = (nsManagedObject.value(forKey: "title") as! String)
        let desc = (nsManagedObject.value(forKey: "desc") as! String)
        let theta = (nsManagedObject.value(forKey: "theta") as! Double)
        let phi = (nsManagedObject.value(forKey: "phi") as! Double)
        let audios = urlDecombiner(combinedString: (nsManagedObject.value(forKey: "audios") as! String))
        let imgs = urlDecombiner(combinedString: (nsManagedObject.value(forKey: "imgs") as! String))
        let landmarks = stringDecombiner(combinedString: (nsManagedObject.value(forKey: "landmarks") as! String))
        initFromData(title: title, desc: desc, theta: theta, phi: phi, audios: audios, imgs: imgs, landmarks: landmarks)
        
    }
    func initFromCodable(codable: docButton)  {
        initFromData(title: codable.title, desc: codable.desc, theta: codable.theta, phi: codable.phi, audios: codable.audios, imgs: codable.imgs, landmarks: codable.landmarks)
    }
    func initFromData(title: String?, desc: String?, theta: Double, phi: Double, audios: [String], imgs: [String], landmarks: [String]) {
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
        for link in audios {
            if !link.isEmpty{
                checkBookFileExists(withLink: link){ [weak self] downloadedURL in
                    guard let self = self else{
                        return
                    }
                    self.audios.append(downloadedURL)
                }
            }
        }
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
            }/*
            if let imgData = Data(base64Encoded: i) {
                if let img = UIImage(data: imgData) {
                    imgs.append(img)
                }
            }*/
        }
        for l in landmarks {
            self.landmarks.append(l)
        }
        let theta = (theta * Double.pi / 180)
        let phi = (phi * Double.pi / 180)
        self.vector = SCNVector3(90 * sin(phi) * cos(theta), 90 * sin(phi) * sin(theta), 90 * cos(phi))
            
  
        
        // copied from init
        let plane = SCNPlane(width: size, height: size)
        plane.firstMaterial!.diffuse.contents = img
        self.node = SCNNode(geometry: plane)
        self.node.position = vector
        self.node.constraints = [SCNBillboardConstraint()]
        self.node.name = desc

    }
    init (landmarks: [String]=[], title: String?=nil, desc: String?=nil, audios: [URL]=[], imgs: [UIImage]=[], vector: SCNVector3=SCNVector3(0, 0, 0)){
        self.vector = vector
        self.landmarks = landmarks
        self.desc = desc
        self.title = title
        self.audios = audios
        self.imgs = imgs
        
        img = UIImageView(image: (UIImage(systemName: icon1)!).withRenderingMode(.alwaysTemplate), highlightedImage: (UIImage(systemName: icon2)!).withRenderingMode(.alwaysTemplate))
        img.tintColor = color
        
        let plane = SCNPlane(width: size, height: size)
        plane.firstMaterial!.diffuse.contents = img
        self.node = SCNNode(geometry: plane)
        self.node.constraints = [SCNBillboardConstraint()]
        
        
        self.node.position = vector
        self.node.name = desc
    }
}
