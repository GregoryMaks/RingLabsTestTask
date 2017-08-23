//
//  AuthorDateFormatter.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


class AuthorDateFormatter {
    
    lazy var calendar: Calendar = {
        return Calendar(identifier: Calendar.Identifier.gregorian)
    }()
    
    func stringValue(forAuthor author: String, date: Date) -> String {
        return "by \(author) " + timeDifferenceString(from: date)
    }
    
    private func timeDifferenceString(from fromDate: Date, to toDate: Date = Date()) -> String {
        let components = calendar.dateComponents([.hour, .minute], from: fromDate, to: toDate)
        switch (components.hour!, components.minute!) {
        case (let hours, _) where hours > 0:
            return "\(hours)h ago"
        case (_, let minutes) where minutes > 0:
            return "\(minutes)m ago"
        default:
            return "few moments ago"
        }
    }
    
}
