//
//  ButtonDetailView.swift
//  sfthickmap
//
//  Created by devstudio on 11/17/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//


import SwiftUI
import PartialSheet

struct ButtonDetailView: View {
    @EnvironmentObject var selections: Selections
    @Binding var showButtonDetail: Bool
    @State private var showDetails = false
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    @State private var soundPlaying = false
    
    var body: some View {
        let button = selections.currentButton
        var buttonTitle:String?
        var buttonDesc:String?
        let buttonAudios:[URL]?
        let buttonImgs:[UIImage]?
        
        if button != nil {
            if button!.title != nil && button!.title != "" {
                buttonTitle = button!.title
            } else {
                buttonTitle = nil
            }
            if button!.desc != nil && button!.desc != "" {
                buttonDesc = button!.desc
            } else {
                buttonDesc = nil
            }
            if !button!.audios.isEmpty {
                buttonAudios = button!.audios
            } else {
                buttonAudios = nil
            }
            if !button!.imgs.isEmpty {
                buttonImgs = button!.imgs
            } else {
                buttonImgs = nil
            }
        } else {
            buttonTitle = nil
            buttonDesc = nil
            buttonAudios = nil
            buttonImgs = nil
        }
        return VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    if buttonTitle != nil {
                        Text(buttonTitle!)
                            .font(.headline)
                    }
                }
                    .padding(.leading)
                Spacer()
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                    }) {
                    Image(systemName: "chevron.right")
                        .circleIconButton()
                        .rotationEffect(.degrees(showDetails ? 90 : 0))
                }
                .padding(.trailing)
                Button(action: {
                    self.showButtonDetail = false
                    }) {
                    Image(systemName: "multiply")
                        .circleIconButton()
                }
                .padding(.trailing)
            }
            if showDetails {
                VStack(spacing: 0) {
                    if true {
                        Divider()
                        if buttonImgs != nil {
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack(spacing: 20) {
                                    ForEach(0..<buttonImgs!.count) {
                                        Image(uiImage: buttonImgs![$0])
                                            .resizable()
                                            .aspectRatio(buttonImgs![$0].size, contentMode: .fit)
                                            .frame(maxHeight: height / 4)
                                    }
                                }
                            }
                        }
                    }
                    if buttonDesc != nil {
                        Divider()
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(buttonDesc!)
                                .font(.body)
                                .padding()
                                .animation(.easeInOut(duration: 1.0))
                        }.frame(maxHeight: self.height / 4)
                    }
                    if buttonAudios != nil {
                        Divider()
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(alignment: .center, spacing: 0) {
                                ForEach(0..<buttonAudios!.count) {
                                    AudioPlayerView(audio: buttonAudios![$0])
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
        }.animation(.spring(response: 0.10, dampingFraction: 0.90, blendDuration: 0))
    }
}
