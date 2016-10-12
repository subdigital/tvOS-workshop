//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import AVKit

enum MediaType {
    case movies
    case podcasts
    case musicVideos
    
    var title: String {
        switch self {
        case .movies: return "Movies"
        case .podcasts: return "Podcasts"
        case .musicVideos: return "Music Videos"
        }
    }
    
    func fetch(client: iTunesClient, handler: @escaping iTunesClient.RSSCompletionBlock) {
        switch self {
        case .movies: client.topMovies(completion: handler)
        case .musicVideos: client.topMusicVideos(completion: handler)
        case .podcasts: client.topPodcasts(completion: handler)
        }
    }
}

class ViewController: UICollectionViewController {
    
    var items: [RSSEntry] = []
    
    var mediaType = MediaType.movies

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = mediaType.title
        //let client = iTunesClient()

        // TODO: fetch media
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let entry = items[indexPath.row]
        cell.titleLabel.text = entry.title
        if let url = URL(string: entry.image) {
            cell.loadImage(withURL: url)
        }
        return cell
    }
}
