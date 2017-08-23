//
//  File.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


class CommentFormatter {
    
    func commentString(fromCommentCount commentCount: Int) -> String {
        switch commentCount {
        case 0:
            return "No comments"
        case 1:
            return "1 comment"
        default:
            return "\(commentCount) comments"
        }
    }
    
}
