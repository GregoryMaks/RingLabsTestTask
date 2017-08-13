//
//  RedditListingResponseBuilder.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


class RedditListingResponseBuilder<ServerModel: RawDataInitializable> {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func buildResult() -> Result<RedditListingResponse<ServerModel>, ParsingError> {
        do {
            let rootObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let rootDictionary = rootObject as? [String: Any] else {
                throw ParsingError.wrongType(key: "root")
            }
            
            let dataNode: [String: Any] = try rootDictionary.validatedValue(forKey: "data")
            
            return .success(.init(models: try serverModels(from: dataNode),
                                  pagingMarker: try pagingMarker(from: dataNode)))
        
        } catch let error as ParsingError {
            return .failure(error)
        } catch {
            return .failure(.jsonParsingError(error: error))
        }
    }
    
    // MARK: - Private methods
    
    private func serverModels(from dataNode: [String: Any]) throws -> [ServerModel] {
        let children: [[String: Any]] = try dataNode.validatedValue(forKey: "children")
        return try children.map { try ServerModel(rawData: $0) }
    }
    
    private func pagingMarker(from dataNode: [String: Any]) throws -> RedditListingResponse<ServerModel>.PagingMarker? {
        let after = try dataNode.validatedOptionalValue(forKey: "after") as String?
        let before = try dataNode.validatedOptionalValue(forKey: "before") as String?
        
        if after != nil || before != nil {
            return .init(before: before ?? "", after: after ?? "")
        }
        
        return nil
    }
    
}
