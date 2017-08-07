//
//  RedditPostModel.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


class RedditPostModelBuilder {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func buildModels() -> Result<[RedditPostModel], ParsingError> {
        do {
            let rootObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let rootDictionary = rootObject as? [String: Any] else {
                throw ParsingError.wrongType(key: "root")
            }

            let dataNode: [String: Any] = try rootDictionary.validatedValue(forKey: "data")
            let children: [[String: Any]] = try dataNode.validatedValue(forKey: "children")
            
            return .success(try children.map { try RedditPostModel(rawData: $0) })
        } catch let error as ParsingError {
            return .failure(error)
        } catch {
            return .failure(.jsonParsingError(error: error))
        }
    }
    
}


struct RedditPostModel {
    
    let title: String
    let author: String
    let createdAt: Date
    let commentsCount: Int
    let thumbnailUrl: URL?
    
    /// - Throws: ParsingError
    init(rawData: [String: Any]) throws {
        title = try rawData.validatedValue(forKey: "title")
        author = try rawData.validatedValue(forKey: "author")
        createdAt = try rawData.validatedDate(forKey: "createdAt", converter: { Date.init(timeIntervalSince1970:TimeInterval($0)) } )
        commentsCount = try rawData.validatedValue(forKey: "commentsCount")
        
        if let thumbnail: String = try rawData.validatedOptionalValue(forKey: "thumbnailUrl") {
            thumbnailUrl = (thumbnail == "default") ? nil : URL(string: thumbnail)
        }
        else {
            thumbnailUrl = nil
        }
    }
    
}
