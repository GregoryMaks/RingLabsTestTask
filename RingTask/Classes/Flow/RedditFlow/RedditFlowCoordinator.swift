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
    private let imageLoadingService: ImageLoadingServiceProtocol
    private var listViewController: RedditTopListingViewController?
    
    init(window: UIWindow, networkService: NetworkServiceProtocol, imageLoadingService: ImageLoadingServiceProtocol) {
        self.window = window
        self.networkService = networkService
        self.imageLoadingService = imageLoadingService
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            print("Error, root navigation not found")
            return
        }
        
        guard let viewController = navController.viewControllers.first as? RedditTopListingViewController else {
            print("Root view controller not found")
            return
        }
        
        let viewModel = RedditTopListingViewModel(networkService: networkService,
                                                  imageLoadingService: imageLoadingService)
        viewModel.coordinatorDelegate = self
        viewController.bind(viewModel: viewModel)
        
        listViewController = viewController
        window.rootViewController = navController
    }
    
}


// MARK: - RedditTopListingViewModelCoordinatorDelegate

extension RedditFlowCoordinator: RedditTopListingViewModelCoordinatorDelegate {
    
    // TODO
    
}

