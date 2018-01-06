//
//  TrackTableViewController.swift
//  AudioAnchor
//
//  Created by Joseph Ugowe on 1/5/18.
//  Copyright © 2018 Joseph Ugowe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TrackTableViewController: UITableViewController {
    
    var trackPlaylist: [Track] = []
    let apiClient = APIClient()
    var avPlayer: AVPlayer!
    var isPaused: Bool!
    var currentIndex: Int = Int()
    var currentTrack: Track?
    var currentPlayerStatus: PlayerStatus = .waitingToPlay
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioPlayer.sharedInstance.isPaused = true
        self.setupTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient.fetchAudioTracks { (results, errorMessage) in
            if let results = results{
                self.trackPlaylist = results
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackPlaylist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        
        let track = trackPlaylist[indexPath.row]
        
        cell.trackTitleLabel.text = track.title
        
        track.downloadImage(url: track.imageURL) { (songImage) in
            DispatchQueue.main.async {
                if songImage != nil {
                    cell.trackImage.image = songImage
                }
            }
        }
        
        if currentIndex == indexPath.row {
            cell.backgroundColor = .orange
            cell.togglePlayPause()
            cell.playOrPauseImage.isHidden = false
        } else {
            cell.backgroundColor = .white
            cell.togglePlayPause()
            cell.playOrPauseImage.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = trackPlaylist[indexPath.row]
        currentIndex = indexPath.row
        
        if currentTrack == track {
            if currentPlayerStatus == .paused {
                AudioPlayer.sharedInstance.avPlayer.play()
                AudioPlayer.sharedInstance.isPaused = false
                currentPlayerStatus = .playing
                print(currentPlayerStatus)
            } else if currentPlayerStatus == .playing {
                AudioPlayer.sharedInstance.avPlayer.pause()
                AudioPlayer.sharedInstance.isPaused = true
                currentPlayerStatus = .paused
                print(currentPlayerStatus)
            }
        } else {
            AudioPlayer.sharedInstance.play(url: track.mediaURL)
            AudioPlayer.sharedInstance.isPaused = false
            currentPlayerStatus = .playing
        }
        
        currentTrack = track
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    
    func setupTimer(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func didPlayToEnd() {
        self.playNextTrack(trackPlaylist: trackPlaylist, currentIndex: &currentIndex)
        self.tableView.reloadData()
        print("This beautiful song has ended")
    }
    
    func playNextTrack(trackPlaylist: [Track], currentIndex: inout Int) {
        if (currentIndex < trackPlaylist.count - 1) {
            currentIndex += 1
            AudioPlayer.sharedInstance.isPaused = false
            let nextTrack = trackPlaylist[currentIndex]
            AudioPlayer.sharedInstance.play(url: nextTrack.mediaURL)
            currentTrack = nextTrack
        } else {
            currentIndex = 0
            AudioPlayer.sharedInstance.isPaused = false
            let nextTrack = trackPlaylist[currentIndex]
            AudioPlayer.sharedInstance.play(url: nextTrack.mediaURL)
            currentTrack = nextTrack
        }
    }
}

enum PlayerStatus {
    case waitingToPlay
    case playing
    case paused
}




