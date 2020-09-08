//
//  PanoImageView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/3/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI


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
