//
//  WelcomeView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/3/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    var body: some View {
        return ZStack(alignment: .leading) {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Welcome to")
                            .largeTitle()
                        Spacer()
                    }
                    Text("Shaker Forest Thick Map")
                        .foregroundColor(Color(white: 1, opacity: 0))
                        .largeTitle()
                        .background(LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .mask(Text("Shaker Forest Thick Map")
                            .font(.title)
                            .fontWeight(.semibold))
                }.padding(.bottom, 40.0)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Features")
                            .fontWeight(.semibold)
                            .largeTitle()
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "map.fill")
                            .headlineImage()
                            .padding(.trailing)
                        Text("Annotated map of Shaker Forest and its landmarks")
                            .headline()
                    }.padding([.bottom, .leading, .trailing])
                    HStack {
                        Image(systemName: "qrcode")
                        .headlineImage()
                            .padding(.trailing)
                        Text("QR Code scanning to view annotations in the forest")
                            .headline()
                    }.padding([.bottom, .leading, .trailing])
                    HStack {
                        Image(systemName: "arrow.left.and.right")
                        .headlineImage()
                            .padding(.trailing)
                        Text("360° view of historical forest view at landmark sites")
                            .headline()
                    }.padding([.bottom, .leading, .trailing])
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showWelcome = false
                    }
                    }) {
                        HStack(alignment: .center) {
                            Text("Continue")
                            .title()
                            .padding([.top, .bottom], 10.0)
                            .padding([.leading, .trailing], 50.0)
                            .background(Color.blue
                            .cornerRadius(25))
                            
                        }
                }
            }.padding(20.0)
        }
    }
}
