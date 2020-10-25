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
import MapKit
import UIKit
import PartialSheet

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

class UpdatablePointAnnotation: MKPointAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    /*
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
     */
    var id: Int?
    var desc: String?
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? UpdatablePointAnnotation {
            print(annotation.id!)
        }
    }
    func select() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateAnnotation(currentAnnotation: self)
    }
    init (id: Int?=nil, desc: String?=nil) {
        self.desc = desc
    }
}


public class Landmark: NSObject, MKAnnotation {
    public var title: String?
    public var subtitle: String?
    var desc: String?
    var previewImage: UIImage?
    var panoImage: UIImage
    var panoButtons: [PanoButton]
    @objc dynamic public var coordinate: CLLocationCoordinate2D
    

    init (title: String?, desc: String? = nil, previewImage: UIImage? = nil, panoImage: UIImage, panoButtons: [PanoButton], latitude: Double, longitude: Double){
        self.title = title
        self.desc = desc
        self.previewImage = previewImage
        self.panoImage = panoImage
        self.panoButtons = panoButtons
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
    }
}


class Selections: ObservableObject {
    @Published var currentLandmark: Landmark?
    @Published var currentButton: PanoButton?
    @Published var currentAnnotation: UpdatablePointAnnotation?
    let landmark1 = Landmark(title: "Landmark #1", desc: "landmark #1 description test teste set se test est sdtets est se test estsetests e tst set est esetstst", panoImage: UIImage(imageLiteralResourceName: "landmark1.jpg"), panoButtons: [PanoButton(name: "lb1", desc: "landmark 1, button 1", vector: SCNVector3Make(90,0,0)), PanoButton(name: "l1b2", desc: "landmark 1, button 2", vector: SCNVector3Make(0,90,0)), PanoButton(name: "l1b3", desc: "landmark 1, button 3", vector: SCNVector3Make(0,0,90))], latitude: 43.702634, longitude: -72.286260)
    let landmark2 = Landmark(title: "Landmark #2", panoImage: UIImage(imageLiteralResourceName: "landmark2.jpg"), panoButtons: [PanoButton(name: "l2b1", desc: "landmark 2, button 1", vector: SCNVector3Make(-90,0,0)), PanoButton(name: "l2b2", desc: "landmark 2, button 2", vector: SCNVector3Make(0,-90,0)), PanoButton(name: "l2b3", desc: "landmark 2, button 3", vector: SCNVector3Make(0,0,-90))], latitude: 43.703127, longitude: -72.285018)
    
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
    @EnvironmentObject var partialSheet: PartialSheetManager
    var body: some View {
        ZStack(alignment: .leading) {
            //backgroundColor
            Color(white: 0.8, opacity: 1)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            TabView {
                MapView()
                    .edgesIgnoringSafeArea([.all])
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Map")
                    }

                PanoView()
                    .edgesIgnoringSafeArea([.all])
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Pano Test")
                    }
                
                VStack(alignment: .center) {
                    Spacer()
                        Button(action: {
                            self.partialSheet.showPartialSheet({
                                print("dismissed")
                            }) {
                                AnnotationDetailView()
                            }
                        }, label: {
                            Text("Show Partial Sheet")
                        })
                    Spacer()
                }
                    .addPartialSheet()
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Annotation Detail Test")
                    }
                
            }.zIndex(1)
            
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
