//
//  TrackTableViewCell.swift
//  AudioAnchor
//
//  Created by Joseph Ugowe on 1/5/18.
//  Copyright © 2018 Joseph Ugowe. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var playOrPauseImage: UIImageView!
    
    let playImage = UIImage(named:"play")
    let pauseImage = UIImage(named:"pause")
    
    func togglePlayPause() {
        if AudioPlayer.sharedInstance.isPaused {
            playOrPauseImage.image = playImage
        } else {
            playOrPauseImage.image = pauseImage
        }
    }
    
    func getDataFromURL(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
}
