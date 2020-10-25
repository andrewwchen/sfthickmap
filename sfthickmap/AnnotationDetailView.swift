//
//  AnnotationDetailView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 10/21/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import PartialSheet
import AVKit
import AVFoundation

class PlayerLayerUIView: UIView {
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

struct PlayerLayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerLayerView>) {
        
    }
    func makeUIView(context: Context) -> UIView {
        return PlayerLayerUIView(frame: .zero)
        
    }
    
}


struct AVPlayerView: UIViewControllerRepresentable {

    @Binding var videoURL: URL?
    
    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}


struct AnnotationDetailView: View {
    @EnvironmentObject var selections: Selections
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
    @State private var vURL = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")

    var body: some View {
        let annoTitle = "no title"//selections.currentAnnotation!.title!
        let annoDesc = "no description"//selections.currentAnnotation.desc
        

            
        return VStack {
            Text(annoTitle)
            AVPlayerView(videoURL: self.$vURL).transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.all)
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
