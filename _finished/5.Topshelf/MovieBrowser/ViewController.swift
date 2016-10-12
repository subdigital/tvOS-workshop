//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import AVKit
import MovieBrowserKit

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
        let client = iTunesClient()
        mediaType.fetch(client: client) { result in
            switch result {
            case .Error(let e):
                print("Error fetching content: \(e)")
            case .Success(let items):
                print("Found \(items.count) items")
                items.forEach { item in
                    print("-> \(item.title)")
                }
                self.items = items
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if let preview = item.previewURLValue, let videoURL = URL(string: preview) {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: videoURL)
            print("preview: \(videoURL)")
            present(playerVC, animated: true, completion: { 
                playerVC.player?.play()
            })
        } else {
            print("no valid video URL")
        }
    }
}

