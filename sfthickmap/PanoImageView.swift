//
//  PanoImageView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/3/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import SceneKit


public class PanoButton: NSObject {
    var node: SCNNode
    //var previewImage: Image?
    //var location: CLLocationCoordinate2D
    var vector: SCNVector3
    var desc: String
    
    let img: UIImageView
    func highlight() {
        img.isHighlighted = true
    }
    func unhighlight() {
        img.isHighlighted = false
    }
    init (vector: SCNVector3, desc: String){
        
        self.vector = vector
        self.desc = desc
        
        let icon1 = "plus.circle.fill"
        let icon2 = "plus.circle"
        let color = UIColor(ciColor: .white)
        let size = CGFloat(10)
        
        img = UIImageView(image: (UIImage(systemName: icon1)!).withRenderingMode(.alwaysTemplate), highlightedImage: (UIImage(systemName: icon2)!).withRenderingMode(.alwaysTemplate))
        img.tintColor = color
        
        let plane = SCNPlane(width: size, height: size)
        plane.firstMaterial!.diffuse.contents = img
        self.node = SCNNode(geometry: plane)
        self.node.position = vector
        self.node.constraints = [SCNBillboardConstraint()]
        self.node.name = desc
    }
}


public class Landmark: NSObject {
    var name: String
    var panoImage: UIImage
    var panoButtons: [PanoButton]
    init (name: String, panoImage: UIImage, panoButtons: [PanoButton]){
        self.name = name
        self.panoImage = panoImage
        self.panoButtons = panoButtons
    }
}




struct PanoImageView: UIViewRepresentable {
    @EnvironmentObject var selections: Selections
    func makeUIView(context: Context) -> CTPanoramaView {
        let panoUIView = CTPanoramaView(frame: UIScreen.main.bounds, image: self.selections.currentLandmark!.panoImage, buttons: self.selections.currentLandmark!.panoButtons)
        panoUIView.panoramaType = .spherical
        panoUIView.controlMethod = .motion
        
        return panoUIView
    }

    func updateUIView(_ uiView: CTPanoramaView, context: Context) {
        uiView.image = self.selections.currentLandmark!.panoImage
        uiView.buttons = self.selections.currentLandmark!.panoButtons
    }
}
