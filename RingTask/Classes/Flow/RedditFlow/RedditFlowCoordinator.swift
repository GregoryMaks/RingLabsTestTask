//
//  RedditFlowCoordinator.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/7/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit
import SafariServices


// - Note: inheritance from NSObject required to conform to SFSafariViewControllerDelegate
class RedditFlowCoordinator: NSObject {
    
    let window: UIWindow
    
    fileprivate let networkService: NetworkServiceProtocol
    fileprivate let imageLoadingService: ImageLoadingServiceProtocol
    
    fileprivate var navigationController: UINavigationController?
    fileprivate var listViewController: RedditTopListingViewController?
    fileprivate var safariViewController: SFSafariViewController?
    
    init(window: UIWindow, networkService: NetworkServiceProtocol, imageLoadingService: ImageLoadingServiceProtocol) {
        self.window = window
        self.networkService = networkService
        self.imageLoadingService = imageLoadingService
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Error, root navigation not found")
        }
        
        guard let viewController = navController.viewControllers.first as? RedditTopListingViewController else {
            fatalError("Root view controller not found")
        }
        
        let viewModel = RedditTopListingViewModel(networkService: networkService,
                                                  imageLoadingService: imageLoadingService)
        viewModel.coordinatorDelegate = self
        viewController.bind(viewModel: viewModel)
        
        navigationController = navController
        listViewController = viewController
        
        window.rootViewController = navController
    }
    
}


// MARK: - RedditTopListingViewModelCoordinatorDelegate

extension RedditFlowCoordinator: RedditTopListingViewModelCoordinatorDelegate {
    
    func viewModel(_ viewModel: RedditTopListingViewModel, openLinkAt url: URL) {
        guard let navigationController = navigationController else {
            return
        }
        
        let viewController = SFSafariViewController(url: url)
        viewController.delegate = self
        navigationController.present(viewController, animated: true, completion: nil)
        
        safariViewController = viewController
    }
    
}


// MARK: - SFSafariViewControllerDelegate

extension RedditFlowCoordinator: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        safariViewController?.dismiss(animated: true)
    }
    
}
