//
//  PanoDetailView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/7/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI

struct PanoDetailView: View {
    @EnvironmentObject var selections: Selections
    var body: some View {
        NavigationView {
            let buttonName = selections.getButtonName()
            let buttonDesc = selections.getButtonDesc()
            Text(buttonDesc)
                .navigationBarTitle(Text(buttonName), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        self.selections.currentButton = nil
                    }
                }) {
                    Text("Done").bold()
                })
            
        }
    }
}
