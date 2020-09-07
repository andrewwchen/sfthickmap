//
//  ContentView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 8/26/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import SceneKit

class Selections: ObservableObject {
    @Published var currentLandmark: Landmark?
    @Published var currentButton: PanoButton?
    let landmark1 = Landmark(name: "Landmark #1", panoImage: UIImage(imageLiteralResourceName: "landmark1.jpg"), panoButtons: [PanoButton(vector: SCNVector3Make(90,0,0), desc: "landmark 1, button 1"), PanoButton(vector: SCNVector3Make(0,90,0), desc: "landmark 1, button 2"), PanoButton(vector: SCNVector3Make(0,0,90), desc: "landmark 1, button 3")])
    let landmark2 = Landmark(name: "Landmark #2", panoImage: UIImage(imageLiteralResourceName: "landmark2.jpg"), panoButtons: [PanoButton(vector: SCNVector3Make(-90,0,0), desc: "landmark 2, button 1"), PanoButton(vector: SCNVector3Make(0,-90,0), desc: "landmark 2, button 2"), PanoButton(vector: SCNVector3Make(0,0,-90), desc: "landmark 2, button 3")])
    
    func toggleLandmark() {
        if currentLandmark == landmark1 {
            currentLandmark = landmark2
        } else {
            currentLandmark = landmark1
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
    //@EnvironmentObject var selections: Selections
    var body: some View {
        ZStack(alignment: .leading) {
            //backgroundColor
            Color(white: 0.8, opacity: 1)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            if showWelcome {
                WelcomeView(showWelcome: self.$showWelcome)
                    .transition(.move(edge: .top))
                    .zIndex(2)
            }
            PanoView().zIndex(1) //TEMP - MapView will go here
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
