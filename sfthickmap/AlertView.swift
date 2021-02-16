//
//  AlertView.swift
//  sfthickmap
//
//  Created by devstudio on 1/28/21.
//  Copyright © 2021 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    var text: String
    var color: Color
    @Binding var showAlerts: Bool
    var body: some View {
        HStack {
            Spacer()
            if showAlerts {
                Text(text)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(color.opacity(Config.buttonOpacity).blur(radius: CGFloat(Config.buttonBlur)))
                    .clipShape(RoundedRectangle(cornerRadius: 44.0 / 4, style: .continuous))
            }
            Spacer()
        }
    }
}
