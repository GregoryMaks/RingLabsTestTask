//
//  RedditListingResponse.swift
//  RingTask
//
//  Created by Gregory on 8/12/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


struct RedditListingResponse<ServerModel: RawDataInitializable> {
    
    static func empty<ServerModel>() -> RedditListingResponse<ServerModel> {
        return RedditListingResponse<ServerModel>(models: [], pagingMarker: nil)
    }
    
    let models: [ServerModel]
    let pagingMarker: RedditPagingMarker?
    
}
