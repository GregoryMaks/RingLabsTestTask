//
//  ParsingError.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/7/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

enum ParsingError: Error {
    
    case missingValue(key: String)
    case wrongType(key: String)
    case jsonParsingError(error: Error)
}
