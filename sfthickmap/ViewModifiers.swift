//
//  ViewModifiers.swift
//  sfthickmap
//
//  Created by devstudio on 12/17/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI

/// ViewModifier for Images to create square-shaped button images
struct SquareIconButton: ViewModifier {
    @EnvironmentObject var settings: Settings
    
    var trigger: Bool
    var highlightColor: Color
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: self.settings.buttonSize / 2, weight: weight))
            .aspectRatio(contentMode: .fill)
            .frame(width: self.settings.buttonSize, height: self.settings.buttonSize)
            .background(Config.buttonBackgroundColor.opacity(Config.buttonOpacity).blur(radius: CGFloat(Config.buttonBlur)))
            .clipShape(RoundedRectangle(cornerRadius: self.settings.buttonSize / 4, style: .continuous))
            .foregroundColor(trigger ? highlightColor : Config.buttonForegroundColor.opacity(Config.buttonOpacity))
    }
}

/// ViewModifier for Images to create circle-shaped button images
struct CircleIconButton: ViewModifier {
    @EnvironmentObject var settings: Settings
    
    var trigger: Bool
    var highlightColor: Color
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: self.settings.buttonSize / 2, weight: weight))
            .aspectRatio(contentMode: .fill)
            .frame(width: self.settings.buttonSize, height: self.settings.buttonSize)
            .background(Config.buttonBackgroundColor.opacity(Config.buttonOpacity).blur(radius: CGFloat(Config.buttonBlur)))
            .clipShape(Circle())
            .foregroundColor(trigger ? highlightColor : Config.buttonForegroundColor.opacity(Config.buttonOpacity))
    }
}

extension View {
    func squareIconButton(trigger: Bool=false, highlightColor: Color=Config.buttonForegroundColor, weight: Font.Weight = .regular) -> some View {
        self.modifier(SquareIconButton(trigger: trigger, highlightColor: highlightColor, weight: weight))
    }
    func circleIconButton(trigger: Bool=false, highlightColor: Color=Config.buttonForegroundColor, weight: Font.Weight = .regular) -> some View {
        self.modifier(CircleIconButton(trigger: trigger, highlightColor: highlightColor, weight: weight))
    }
}
