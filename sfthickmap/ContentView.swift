//
//  ContentView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 8/26/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI

let backgroundColor = Color(white: 0.12, opacity: 1)


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            //.fontWeight(.bold)
            .foregroundColor(Color.white)
    }
}
extension View {
    func title() -> some View {
        self.modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Welcome to")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("Shaker Forest Thick Map")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(white: 1, opacity: 0))
                        .background(LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .mask(Text("Shaker Forest Thick Map")
                            .font(.title)
                            .fontWeight(.semibold))
                }.padding(.bottom, 40.0)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Features")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    HStack {
                        Image("map.fill")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 30, height: 30)
                            .padding(.trailing)
                        Text("Annotated map of Shaker Forest and its landmarks")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }.padding([.bottom, .leading, .trailing])
                    HStack {
                        Image("qrcode")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 30, height: 30)
                            .padding(.trailing)
                        Text("QR Code scanning to view annotations in the forest")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }.padding([.bottom, .leading, .trailing])
                    HStack {
                        Image("arrow.left.and.right")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 30, height: 30)
                            .padding(.trailing)
                        Text("360° view of historical forest view at landmark sites")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }.padding([.bottom, .leading, .trailing])
                }
                Spacer()
                Button(action: {
                    print("button press")
                    }) {
                        HStack(alignment: .center) {
                            Text("Continue")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
