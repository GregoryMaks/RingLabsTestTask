//
//  RedditFlowCoordinator.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/7/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class RedditFlowCoordinator {
    
    let window: UIWindow
    
    private let networkService: NetworkServiceProtocol
    private var listViewController: RedditPostListViewController?
    
    init(window: UIWindow, networkService: NetworkServiceProtocol) {
        self.window = window
        self.networkService = networkService
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            print("Error, root navigation not found")
            return
        }
        
        guard let viewController = navController.viewControllers.first as? RedditPostListViewController else {
            print("Root view controller not found")
            return
        }
        
        listViewController = viewController
        window.rootViewController = listViewController
    }
    
}
