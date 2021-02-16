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
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Welcome to")
                        .font(Font.system(.largeTitle).weight(.bold))
                        .padding(.top)
                    Spacer()
                }
                Text("Shaker Forest Thick Map")
                    .foregroundColor(Color(white: 1, opacity: 0))
                    .font(Font.system(.largeTitle).weight(.bold))
                    .background(LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .mask(Text("Shaker Forest Thick Map")
                        .font(.title)
                        .fontWeight(.semibold))
            }.padding(.bottom, 40.0)
            VStack(alignment: .leading) {
                HStack {
                    Text("Features")
                        .fontWeight(.semibold)
                        .font(Font.system(.largeTitle).weight(.bold))
                    Spacer()
                }
                HStack {
                    Image(systemName: "map.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                    Text("Annotated map of Shaker Forest and its landmarks")
                        .font(Font.system(.headline))
                }.padding([.bottom, .leading, .trailing])
                HStack {
                    Image(systemName: "qrcode")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                    Text("QR Code scanning to view annotations in the forest")
                        .font(Font.system(.headline))
                }.padding([.bottom, .leading, .trailing])
                HStack {
                    Image(systemName: "arrow.left.and.right")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                    Text("360° view of historical forest view at landmark sites")
                        .font(Font.system(.headline))
                }.padding([.bottom, .leading, .trailing])
            }
            Spacer()
            Button(action: {
                    self.showWelcome = false
                }) {
                    HStack(alignment: .center) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 10.0)
                            .padding([.leading, .trailing], 50.0)
                            .background(Color.blue.cornerRadius(25))
                            .font(Font.system(.title).weight(.semibold))
                    }
            }
        }.padding(20.0)
    }
}
