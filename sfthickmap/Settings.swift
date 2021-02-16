//
//  Settings.swift
//  sfthickmap
//
//  Created by devstudio on 12/17/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import AVFoundation

/// User settings and onboarded state stored and referenced throughout SwiftUI views
class Settings: ObservableObject {
    let defaults = UserDefaults.standard
    let appDefaults: [String : Any] = ["buttonSize": Config.buttonSize, "scanInterval": Config.scanInterval, "onboarded": Config.onboarded, "frontCamera": Config.frontCamera]
    @Published var buttonSize: CGFloat
    @Published var scanInterval: Double
    @Published var cameraPosition: AVCaptureDevice.Position
    @Published var onboarded: Bool
    
    init() {
        self.defaults.register(defaults: appDefaults)
        self.buttonSize = CGFloat(self.defaults.float(forKey: "buttonSize"))
        self.scanInterval = self.defaults.double(forKey: "scanInterval")
        
        if self.defaults.bool(forKey: "frontCamera") {
            self.cameraPosition = AVCaptureDevice.Position.front
        } else {
            self.cameraPosition = AVCaptureDevice.Position.back
        }
        self.onboarded = self.defaults.bool(forKey: "onboarded")
    }
}
