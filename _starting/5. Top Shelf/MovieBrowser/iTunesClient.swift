//
//  iTunesClient.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Error(Error)
}

class iTunesClient {
    let configuration: URLSessionConfiguration
    let session: URLSession
    
    typealias RSSCompletionBlock = (Result<[RSSEntry]>) -> Void
    
    init() {
        configuration = .default
        session = URLSession(configuration: configuration)
    }
    
    private func fetchRSS(url: URL, completion: @escaping RSSCompletionBlock) {
        let task = session.dataTask(with: url) {
            data, response, error in
            
            if let e = error {
                print("Error: \(e)")
                DispatchQueue.main.async {
                    completion(.Error(e))
                }
            } else {
                let http = response as! HTTPURLResponse
                print("Received HTTP \(http.statusCode)")
                switch http.statusCode {
                case 200:
                    let parser = RSSParser(data: data!)
                    parser.parse { results in
                        DispatchQueue.main.async {
                            completion(.Success(results))
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completion(.Success([]))
                    }
                }
                
            }
        }
        
        task.resume()

    }
    
    func topMovies(completion: @escaping RSSCompletionBlock) {
        let url = URL(string: "https://itunes.apple.com/us/rss/topmovies/limit=100/xml")!
        fetchRSS(url: url, completion: completion)
    }
    
    func topMusicVideos(completion: @escaping RSSCompletionBlock) {
        let url = URL(string: "https://itunes.apple.com/us/rss/topmusicvideos/limit=100/xml")!
        fetchRSS(url: url, completion: completion)
    }
    
    func topPodcasts(completion: @escaping RSSCompletionBlock) {
        let url = URL(string: "https://itunes.apple.com/us/rss/toppodcasts/limit=100/xml")!
        fetchRSS(url: url, completion: completion)
    }
}
