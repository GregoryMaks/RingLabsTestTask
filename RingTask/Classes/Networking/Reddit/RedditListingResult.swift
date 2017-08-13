//
//  RedditListingResponse.swift
//  RingTask
//
//  Created by Gregory on 8/12/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


struct RedditListingResponse<ServerModel: RawDataInitializable> {
    
    // TODO: I don't like the idea of 4 states hidden inside this entity. Maybe make it enum?
    struct PagingMarker: CustomStringConvertible {
        /// Parameter to use when previous page should be loaded, can be empty string
        let before: String
        
        /// Parameter to use when next page should be loaded, can be empty string
        let after: String
        
        var description: String {
            return "before: \(before), after: \(after)"
        }
    }
    
    static func empty<ServerModel>() -> RedditListingResponse<ServerModel> {
        return RedditListingResponse<ServerModel>(models: [], pagingMarker: nil)
    }
    
    let models: [ServerModel]
    let pagingMarker: PagingMarker?
    
}
