//
//  AudioPlayer.swift
//  AudioAnchor
//
//  Created by Joseph Ugowe on 1/5/18.
//  Copyright © 2018 Joseph Ugowe. All rights reserved.
//

import Foundation
import AVKit

class AudioPlayer {
    
    static let sharedInstance = AudioPlayer()
    
    var avPlayer: AVPlayer = AVPlayer()
    var isPaused: Bool!
    var timer: Timer?
    
    func play(url: URL) {
        self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
        if #available(iOS 10.0, *) {
            self.avPlayer.automaticallyWaitsToMinimizeStalling = false
        }
        avPlayer.volume = 1.0
        avPlayer.play()
    }
    
}
