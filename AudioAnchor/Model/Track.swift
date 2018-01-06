//
//  Track.swift
//  AudioAnchor
//
//  Created by Joseph Ugowe on 1/5/18.
//  Copyright © 2018 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit

class Track {
    
    let title: String
    let mediaURL: URL
    let imageURL: URL
    let index: Int
    var downloaded = false
    
    init(title: String, mediaURL: URL, imageURL: URL, index: Int) {
        self.title = title
        self.mediaURL = mediaURL
        self.imageURL = imageURL
        self.index = index
    }
    
    func downloadImage(url: URL,_ completionHandler: @escaping (_ image: UIImage?) -> () ){
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let imageData = data else { print("Problem parsing imageData"); return}
                
                if let image = UIImage(data: imageData){
                    completionHandler(image)
                }
            }
            }.resume()
    }
}

extension Track: Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        return
            lhs.title == rhs.title &&
                lhs.mediaURL == rhs.mediaURL &&
                lhs.imageURL == rhs.imageURL &&
                lhs.index == rhs.index
    }
}
