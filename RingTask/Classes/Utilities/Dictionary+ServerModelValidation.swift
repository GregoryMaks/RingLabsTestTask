//
//  Dictionary+ServerModelValidation.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/7/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


extension Dictionary where Key: ExpressibleByStringLiteral {
    
    // TODO: make this more functional?
    
    // MARK: - Generic types
    
    func validatedValue<T>(forKey key: Key) throws -> T {
        guard let value = self[key] else {
            throw ParsingError.missingValue(key: key as! String)
        }
        guard let typedValue = value as? T else {
            throw ParsingError.wrongType(key: key as! String)
        }
        return typedValue
    }
    
    func validatedOptionalValue<T>(forKey key: Key) throws -> T? {
        guard let value = self[key],
              (value is NSNull) == false else
        {
            return nil
        }
        guard let typedValue = value as? T else {
            throw ParsingError.wrongType(key: key as! String)
        }
        return typedValue
    }
    
    // MARK: - Concrete types
    
    func validatedDate(forKey key: Key, converter: (Int) -> Date) throws -> Date {
        let dateInt: Int = try validatedValue(forKey: key)
        return Date(timeIntervalSince1970: TimeInterval(dateInt))
    }

    func validatedValue(forKey key: Key) throws -> URL {
        let stringValue: String = try validatedValue(forKey: key)
        
        guard let url = URL(string: stringValue) else {
            throw ParsingError.wrongType(key: key as! String)
        }
        return url
    }
    
    func validatedOptionalValue(forKey key: Key) throws -> URL? {
        let stringValue: String? = try validatedOptionalValue(forKey: key)
        return stringValue.flatMap { URL(string: $0) }
    }
    
}
