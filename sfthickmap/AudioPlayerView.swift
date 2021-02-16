//
//  AudioPlayerView.swift
//  sfthickmap
//
//  Created by devstudio on 1/27/21.
//  Copyright © 2021 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import AVFoundation

var player: AVAudioPlayer?

struct AudioPlayerView: View {
    @EnvironmentObject var selections: Selections
    var audio: URL
    var body: some View {
        Button(action: {
            player?.stop()
            if selections.currentAudio == audio {
                selections.currentAudio = nil
            } else {
                selections.currentAudio = audio
                do {
                    let songData = try NSData(contentsOf: audio, options: NSData.ReadingOptions.mappedIfSafe)
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    player = try AVAudioPlayer(data: songData as Data)
                    player!.prepareToPlay()
                    player!.play()
                } catch {
                    print(error)
                }
            }
            }) {
            Image(systemName: ((player?.isPlaying ?? false) && (selections.currentAudio == audio)) ? "pause.circle" : "play.circle")
                .squareIconButton()
                .animation(.easeInOut)
        }
    }
}
