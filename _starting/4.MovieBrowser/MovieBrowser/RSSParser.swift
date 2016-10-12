//
//  RSSParser.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

class RSSParser : NSObject {
    let xmlParser: XMLParser
    var completionBlock: (([RSSEntry]) -> Void)?
    var results: [RSSEntry]?
    var currentPath = URL(string: "/")!
    
    var currentEntry: [String:Any]?
    
    struct Node {
        let name: String
        var attributes: [String: String] = [:]
        var content: String?
        
        init(name: String) {
            self.name = name
        }
    }
    var currentNode: Node?
    
    init(data: Data) {
        xmlParser = XMLParser(data: data)
        super.init()
        xmlParser.delegate = self
    }
    
    func parse(completion: @escaping ([RSSEntry]) -> Void) {
        completionBlock = completion
        xmlParser.parse()
    }
}

extension RSSParser : XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Started document")
        results = []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Finished parsing")
        
        if let results = results {
            completionBlock?(results)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentPath = currentPath.appendingPathComponent(elementName)
        
        switch elementName {
            case "entry":
                currentEntry = [:]
            case "im:name": fallthrough
            case "im:image": fallthrough
            case "link": fallthrough
            case "title":
                if currentEntry != nil {
                    currentNode = Node(name: elementName)
                    currentNode?.attributes = attributeDict
                }
            
            
            default: break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let node = currentNode, node.name == currentPath.lastPathComponent else {
                        return }
        if currentNode?.content == nil {
            currentNode?.content = string
        } else {
            currentNode?.content?.append(string)
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentPath = currentPath.deletingLastPathComponent()
        switch elementName {
        case "entry":
            if let entry = RSSEntry(dictionary: currentEntry!) {
                results?.append(entry)
            } else {
                print("couldn't parse as entry: \(currentEntry!)")
            }
            currentNode = nil
        case "im:name":
            currentEntry?["title"] = currentNode?.content
        case "im:image":
            if let imageURLString = currentNode?.content {
                currentEntry?["image"] = replaceImageSize(originalURLString: imageURLString)
            }
        case "link":
            if let title = currentNode?.attributes["title"], title == "Preview",
                let type = currentNode?.attributes["type"], type.contains("video"),
                let href = currentNode?.attributes["href"] {
                currentEntry?["preview"] = href
            }
        default:
            break
        }
    }
    
    private func replaceImageSize(originalURLString: String) -> String {
        
        for size in [100, 170] {
            let sizeString = "\(size)x\(size)"
            if originalURLString.contains(sizeString) {
                return originalURLString.replacingOccurrences(of: sizeString, with: "340x340")
            }
        }
        
        return originalURLString
    }
}
