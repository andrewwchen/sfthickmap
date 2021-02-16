//
//  PanoView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/3/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI


struct PanoView: UIViewRepresentable {
    @Binding var landmark: Landmark?
    @Binding var showButtonDetail: Bool
    func makeUIView(context: Context) -> CTPanoramaView {
        let panoUIView: CTPanoramaView
        if self.landmark != nil {
            panoUIView = CTPanoramaView(frame: UIScreen.main.bounds, image: self.landmark!.img, buttons: self.landmark!.panoButtons, showButtonDetail: self.showButtonDetail)
        } else {
            panoUIView = CTPanoramaView(frame: UIScreen.main.bounds, image: nil, buttons: [], showButtonDetail: self.showButtonDetail)
        }
        panoUIView.panoramaType = .spherical
        panoUIView.controlMethod = .motion
        
        return panoUIView
    }

    func updateUIView(_ uiView: CTPanoramaView, context: Context) {
        if self.landmark != nil {
            if uiView.image != self.landmark!.img {
                uiView.image = self.landmark!.img
            }
            uiView.buttons = self.landmark!.panoButtons
            //uiView.showButtonDetail = self.showButtonDetail
        } else {
        }
    }

}
