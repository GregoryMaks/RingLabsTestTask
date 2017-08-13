//
//  RawDataInitializable.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol RawDataInitializable {
    
    init(rawData: [String: Any]) throws
    
}
