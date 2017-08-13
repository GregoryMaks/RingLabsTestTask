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
    
    /// - Throws: ParsingError
    ///
    /// - Expects JSON in form of { kind: "", data: { ...values here... } }
    init(rawData: [String: Any]) throws {
        let dataNode: [String: Any] = try rawData.validatedValue(forKey: "data")
        
        title = try dataNode.validatedValue(forKey: "title")
        author = try dataNode.validatedValue(forKey: "author")
        createdAt = try dataNode.validatedDate(forKey: "created",
                                               converter: { Date.init(timeIntervalSince1970:TimeInterval($0)) } )
        commentsCount = try dataNode.validatedValue(forKey: "num_comments")
        thumbnailUrl = try dataNode.validatedOptionalValue(forKey: "thumbnail").flatMap {
            ($0 == "default") ? nil : URL(string: $0)
        }
    }
    
}
