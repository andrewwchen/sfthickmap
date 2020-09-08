//
//  ContentView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 8/26/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import SceneKit
import Combine


public class PanoButton: NSObject {
    //@EnvironmentObject var selections: Selections
    //var selections
    var node: SCNNode
    //var previewImage: Image?
    //var location: CLLocationCoordinate2D
    var vector: SCNVector3
    var name: String
    var desc: String
    
    let img: UIImageView
    func highlight() {
        img.isHighlighted = true
    }
    func unhighlight() {
        img.isHighlighted = false
    }
    func select() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateButton(currentButton: self)
    }
    init (name: String, desc: String, vector: SCNVector3){
        self.vector = vector
        self.desc = desc
        self.name = name
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


class Selections: ObservableObject {
    @Published var currentLandmark: Landmark?
    @Published var currentButton: PanoButton?
    let landmark1 = Landmark(name: "Landmark #1", panoImage: UIImage(imageLiteralResourceName: "landmark1.jpg"), panoButtons: [PanoButton(name: "lb1", desc: "landmark 1, button 1", vector: SCNVector3Make(90,0,0)), PanoButton(name: "l1b2", desc: "landmark 1, button 2", vector: SCNVector3Make(0,90,0)), PanoButton(name: "l1b3", desc: "landmark 1, button 3", vector: SCNVector3Make(0,0,90))])
    let landmark2 = Landmark(name: "Landmark #2", panoImage: UIImage(imageLiteralResourceName: "landmark2.jpg"), panoButtons: [PanoButton(name: "l2b1", desc: "landmark 2, button 1", vector: SCNVector3Make(-90,0,0)), PanoButton(name: "l2b2", desc: "landmark 2, button 2", vector: SCNVector3Make(0,-90,0)), PanoButton(name: "l2b3", desc: "landmark 2, button 3", vector: SCNVector3Make(0,0,-90))])
    
    func toggleLandmark() {
        if currentLandmark == landmark1 {
            currentLandmark = landmark2
        } else {
            currentLandmark = landmark1
        }
    }
    func getButtonName() -> String {
        if currentButton != nil {
            return currentButton!.name
        } else {
            return "No name"
        }
    }
    func getButtonDesc() -> String {
        if currentButton != nil {
            return currentButton!.desc
        } else {
            return "No description"
        }
    }
    
    init() {
        currentLandmark = landmark1
    }
    
}


let backgroundColor = Color(white: 0.12, opacity: 1)
let textColor = Color.white


struct LargeTitle: ViewModifier {
    let font = Font.system(.largeTitle).weight(.bold)
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(textColor)
    }
}

struct Title: ViewModifier {
    let font = Font.system(.title).weight(.semibold)
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(textColor)
    }
}


struct Headline: ViewModifier {
    let font = Font.system(.headline)//.weight(.bold)
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(textColor)
    }
}


struct GradientText: ViewModifier {
    let font = Font.system(.largeTitle).weight(.semibold)
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.white)
            //.fontWeight(.bold)
    }
}



extension View {
    func largeTitle() -> some View {
        self.modifier(LargeTitle())
    }
    func title() -> some View {
        self.modifier(Title())
    }
    func headline() -> some View {
        self.modifier(Headline())
    }
    func gradientText() -> some View {
        self.modifier(GradientText())
    }
}

extension Image {
    func headlineImage() -> some View {
        self
            .resizable()
            .foregroundColor(textColor)
            .frame(width: 30, height: 30)
    }
}


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
        let removal = AnyTransition.move(edge: .top)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}




struct ContentView: View {
    @State var showWelcome = true
    @State var showPanoDetail = false
    @EnvironmentObject var selections: Selections
    var body: some View {
        ZStack(alignment: .leading) {
            //backgroundColor
            Color(white: 0.8, opacity: 1)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)

            PanoView().zIndex(1) //TEMP - MapView will go here
            .sheet(isPresented: $showWelcome) {
                WelcomeView(showWelcome: self.$showWelcome)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
