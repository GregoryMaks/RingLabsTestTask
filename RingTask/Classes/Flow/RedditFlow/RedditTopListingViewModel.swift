//
//  RedditTopListingViewModel.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol RedditTopListingViewModelCoordinatorDelegate: class {
    
    // TODO
    
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
    
}
