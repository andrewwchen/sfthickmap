//
//  AnnotationDetailView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 10/21/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import Foundation
import SwiftUI
import PartialSheet
import AVKit


class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!
        let player = AVPlayer(url: url)
        player.play()
        playerLayer.player = player
        layer.addSublayer(playerLayer)
  
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

}

struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
        
    }
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero)
        
    }
    
}

struct AnnotationDetailView: View {
    @EnvironmentObject var selections: Selections
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    var body: some View {
        let annoTitle = "no title"//selections.currentAnnotation!.title!
        let annoDesc = "no description"//selections.currentAnnotation.desc
        return VStack {
                Text(annoTitle)
                PlayerView()
                Text(annoDesc)
                Button(action: {
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
        }
    }
}
