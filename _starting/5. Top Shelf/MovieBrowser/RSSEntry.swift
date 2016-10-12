//
//  RSSItem.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

struct RSSEntry {
    
    let title: String
    let image: String
    let previewURLValue: String?
    
    init?(dictionary: [String : Any]) {
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
