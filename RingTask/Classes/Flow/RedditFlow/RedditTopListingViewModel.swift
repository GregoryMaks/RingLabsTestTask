//
//  RedditTopListingViewModel.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation
import UIKit


protocol RedditTopListingViewModelCoordinatorDelegate: class {
    
    func viewModel(_ viewModel: RedditTopListingViewModel, openLinkAt url: URL)
    
}


class RedditTopListingViewModel {
    
    enum Error: Swift.Error, Descriptable {
        case unableToOpenPostUrl
        case noImageAttached
        case failedToSaveImage
        
        var stringDescription: String {
            switch self {
            case .unableToOpenPostUrl:
                return "Unable to open post link"
            case .noImageAttached:
                return "No image attached"
            case .failedToSaveImage:
                return "Failed to save image, probably wrong format"
            }
        }
    }
    
    let imageLoadingService: ImageLoadingServiceProtocol
    let dataSource: RedditTopListingDataSource
    
    weak var coordinatorDelegate: RedditTopListingViewModelCoordinatorDelegate?
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, imageLoadingService: ImageLoadingServiceProtocol) {
        dataSource = RedditTopListingDataSource(networkService: networkService)
        self.imageLoadingService = imageLoadingService
    }
    
    // MARK: - Public
    
    func saveImageToGallery(for itemModel: RedditPostServerModel,
                            completion: @escaping (Result<Void, Error>) -> Void)
    {
        guard let imageUrl = itemModel.imageUrl else {
            completion(.failure(.noImageAttached))
            return
        }
        
        imageLoadingService.loadImage(for: imageUrl) { loadResult in
            switch loadResult {
            case .success(let image):
                ImageCameraRollSaver().saveImageToCameraRoll(image: image) { result in
                    completion(
                        result.flatMapBoth(ifSuccess: { .success(()) },
                                           ifFailure: { _ in .failure(.failedToSaveImage) })
                    )
                }

            case .failure(_):
                completion(.failure(.failedToSaveImage))
            }
        }
    }
    
    func openLink(for itemModel: RedditPostServerModel) -> Result<Void, RedditTopListingViewModel.Error> {
        if let contentUrl = itemModel.url {
            coordinatorDelegate?.viewModel(self, openLinkAt: contentUrl)
            return .success(())
        } else {
            return .failure(.noImageAttached)
        }
    }
    
}
