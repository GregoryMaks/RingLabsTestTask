//
//  ImageLoadingService.swift
//  RingTask
//
//  Created by Gregory on 8/14/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


protocol ImageLoadingServiceProtocol {
    
    @discardableResult func loadImage(for url: URL,
                                      completion: @escaping (Result<UIImage, ImageLoadingService.Error>) -> Void)
        -> URLSessionDataTask
    
}


class ImageLoadingService: ImageLoadingServiceProtocol {
    
    enum Error: Swift.Error {
        case unableToCreateImage
        case serverError(statusCode: Int)
        case networkError(error: NetworkError)
    }
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, queue: DispatchQueue = .main) {
        self.networkService = networkService
        self.queue = queue
    }
    
    // MARK: - Public methods
    
    @discardableResult func loadImage(for url: URL,
                                      completion: @escaping (Result<UIImage, ImageLoadingService.Error>) -> Void)
        -> URLSessionDataTask
    {
        return networkService.perform(request: URLRequest(url: url)) { [weak self] result in
            guard let `self` = self else { return }
            self.queue.async {
                completion(
                    result.flatMapBoth(ifSuccess: self.verifyServerResponse, ifFailure: self.networkErrorToResult)
                          .flatMapBoth(ifSuccess: self.createImageFromData, ifFailure: liftError)
                )
            }
        }
    }
    
    // MARK: - Private methods
    
    private func verifyServerResponse(_ response: (data: Data?, urlResponse: HTTPURLResponse))
        -> Result<Data?, ImageLoadingService.Error>
    {
        if HttpStatus(response.urlResponse).isOk {
            return .success(response.0)
        } else {
            return .failure(.serverError(statusCode: response.urlResponse.statusCode))
        }
    }
    
    private func createImageFromData(_ data: Data?) -> Result<UIImage, ImageLoadingService.Error> {
        guard let data = data else {
            return .failure(.unableToCreateImage)
        }
        
        return UIImage(data: data).flatMap { .success($0) } ?? .failure(.unableToCreateImage)
    }
    
    // MARK: - Helper methods
    
    private func networkErrorToResult(_ error: NetworkError) -> Result<Data?, ImageLoadingService.Error> {
        return .failure(.networkError(error: error))
    }
    
}
