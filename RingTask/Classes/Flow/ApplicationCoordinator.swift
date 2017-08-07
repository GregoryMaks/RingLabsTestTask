//
//  ApplicationCoordinator.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/7/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class ApplicationCoordinator {

    let window: UIWindow
    var redditFlowCoordinator: RedditFlowCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let redditFlowCoordinator = RedditFlowCoordinator(window: window)
        redditFlowCoordinator.start()
        self.redditFlowCoordinator = redditFlowCoordinator
    }
    
}
