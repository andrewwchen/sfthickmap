//
//  PanoView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/6/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import SceneKit

struct PanoView: View {
    @EnvironmentObject var selections: Selections
    var body: some View {
        ZStack() {
            if self.selections.currentLandmark != nil {
                PanoImageView()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(0)
                VStack() {
                    Text(self.selections.currentLandmark!.name)
                        .headline()
                        .padding()
                    Spacer()
                    Button(action: {
                        self.selections.toggleLandmark()
                        }) {
                            Text("Toggle Landmark")
                                .title()
                                .padding([.top, .bottom], 10.0)
                                .padding([.leading, .trailing], 50.0)
                                .background(Color.blue
                                .cornerRadius(25))
                    }
                }.zIndex(1)
                
            }
            if selections.currentButton != nil {
                PanoDetailView()
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
    }
    
}

struct PanoView_Previews: PreviewProvider {
    static var previews: some View {
        PanoView()
    }
}
