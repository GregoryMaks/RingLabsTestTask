//
//  RedditPostServerModel.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


struct RedditPostServerModel: RawDataInitializable {
    
    let title: String
    let author: String
    let createdAt: Date
    let commentsCount: Int
    let thumbnailUrl: URL?
    let imageUrl: URL?
    let url: URL?
    
    /// - Throws: ParsingError
    ///
    /// - Expects JSON in form of { kind: "", data: { ...values here... } }
    init(rawData: [String: Any]) throws {
        let dataNode: [String: Any] = try rawData.validatedValue(forKey: "data")
        
        title = try dataNode.validatedValue(forKey: "title")
        author = try dataNode.validatedValue(forKey: "author")
        createdAt = try dataNode.validatedDate(forKey: "created", converter: Date.init(timeIntervalSince1970:))
        commentsCount = try dataNode.validatedValue(forKey: "num_comments")
        thumbnailUrl = try dataNode.validatedOptionalValue(forKey: "thumbnail").flatMap {
            ($0 == "default") ? nil : URL(string: $0)
        }
        
        url = try dataNode.validatedOptionalValue(forKey: "url")
        
        if let previewNode: [String: Any] = try dataNode.validatedOptionalValue(forKey: "preview"),
            let imagesNodes: [[String: Any]] = try previewNode.validatedOptionalValue(forKey: "images"),
            let imageNode = imagesNodes.first,
            let sourceNode: [String: Any] = try imageNode.validatedOptionalValue(forKey: "source"),
            let sourceUrl: URL = try sourceNode.validatedOptionalValue(forKey: "url")
        {
            imageUrl = sourceUrl
        }
        else {
            imageUrl = nil
        }
    }
    
}
