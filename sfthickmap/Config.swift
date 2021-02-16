//
//  Config.swift
//  sfthickmap
//
//  Created by devstudio on 12/16/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI

/// Static variables for configuring "sfthickmap" within Xcode
struct Config {
    static let buttonOpacity = 0.70
    static let buttonBlur = 0.70
    static let buttonBackgroundColor = Color(.tertiarySystemGroupedBackground)
    static let buttonForegroundColor = Color(.label)
    
    static let noteColor = Color(.blue)
    static let warningColor = Color(.yellow)
    static let alertColor = Color(.red)
    
    /// Default values for the Settings struct
    static let buttonSize = 48.0
    static let maxButtonSize = 64.0
    static let minButtonSize = 48.0
    
    static let scanInterval = 1.0
    static let minScanInterval = 1.0
    static let maxScanInterval = 5.0
    
    static let onboarded = false
    static let frontCamera = false
}
