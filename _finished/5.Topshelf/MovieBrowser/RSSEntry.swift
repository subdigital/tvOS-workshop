//
//  RSSItem.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

public struct RSSEntry {
    
    public let title: String
    public let image: String
    public let previewURLValue: String?
    
    public init?(dictionary: [String : Any]) {
        guard
            let title = dictionary["title"] as? String,
            let image = dictionary["image"] as? String,
            let preview = dictionary["preview"] as? String?
            else {
                return nil
        }
        
        self.title = title
        self.image = image
        self.previewURLValue = preview
    }
}
