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
    
    private var redditFlowCoordinator: RedditFlowCoordinator?
    private let networkService: NetworkServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol
    
    init(window: UIWindow) {
        self.window = window
        self.networkService = NetworkService()
        self.imageLoadingService = ImageLoadingService(networkService: networkService)
    }
    
    func start() {
        let container = dependencyContainer(
            { self.networkService },
            { self.imageLoadingService }
        )
        
        let redditFlowCoordinator = RedditFlowCoordinator(window: window, dependencyContainer: container)
        redditFlowCoordinator.start()
        self.redditFlowCoordinator = redditFlowCoordinator
    }
    
}

