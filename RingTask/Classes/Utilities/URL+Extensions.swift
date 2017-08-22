//
//  URL+Extensions.swift
//  RingTask
//
//  Created by Gregory on 8/15/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


extension URL {
    
    func urlWith(query: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.query = query
        return components?.url
    }
    
}
