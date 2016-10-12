//
//  ServiceProvider.swift
//  MovieBrowserTopShelf
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import TVServices
import MovieBrowserKit

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        return .sectioned
    }

    var topShelfItems: [TVContentItem] {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let client = iTunesClient()
        
        let sectionIdentifier = TVContentIdentifier(identifier: "Movies", container: nil)!
        let section = TVContentItem(contentIdentifier: sectionIdentifier)!
        
        client.topMovies(limit: 10) { result in
            switch result {
            case .Success(let entries):
                section.topShelfItems = entries.map { self.contentItem(for: $0, inContainer: sectionIdentifier) }
            case .Error(let e):
                print("Error: \(e)")
                break
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return [section]
    }

    private func contentItem(for entry: RSSEntry, inContainer container: TVContentIdentifier?) -> TVContentItem {
        let id = TVContentIdentifier(identifier: entry.title, container: container)!
        let item = TVContentItem(contentIdentifier: id)!
        item.imageShape = .poster
        item.imageURL = URL(string: entry.image)
        item.title = entry.title
        return item
    }
}

