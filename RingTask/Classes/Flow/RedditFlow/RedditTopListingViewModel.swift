//
//  RedditTopListingViewModel.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol RedditTopListingViewModelCoordinatorDelegate: class {
    
    func viewModel(_ viewModel: RedditTopListingViewModel, openLinkAt url: URL)
    
}


class RedditTopListingViewModel {
    
    let imageLoadingService: ImageLoadingServiceProtocol
    let dataSource: RedditTopListingDataSource
    
    weak var coordinatorDelegate: RedditTopListingViewModelCoordinatorDelegate?
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, imageLoadingService: ImageLoadingServiceProtocol) {
        dataSource = RedditTopListingDataSource(networkService: networkService)
        self.imageLoadingService = imageLoadingService
    }
    
    // MARK: - Public
    
    func userDidSelectItem(atIndex index: Int) {
        let itemModel = dataSource.models[index]
        if let contentUrl = itemModel.url {
            coordinatorDelegate?.viewModel(self, openLinkAt: contentUrl)
        } else {
            print("unable to open item url")
        }
    }
    
}
