//
//  RedditService.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation

class RedditService {

    // MARK: - Subtypes
    
    private struct Constants {
        static let apiUrl = URL(string: "https://api.reddit.com")!
        
        static var topPostsAbsoluteURL: URL {
            return URL(string: "top", relativeTo: apiUrl)!
        }
    }
    
    enum RedditError: Error {
        case networkError(error: NetworkError)
        case serverError(statusCode: Int)
        case parsingError(error: ParsingError)
    }
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, queue: DispatchQueue = DispatchQueue.main) {
        self.networkService = networkService
        self.queue = queue
    }
    
    func requestTopPosts(completion: @escaping (Result<RedditListingResponse<RedditPostServerModel>, RedditError>) -> Void) {
        let request = URLRequest(url: Constants.topPostsAbsoluteURL)
        networkService.perform(request: request) {
            completion(
                $0.flatMap(ifSuccess: self.verifyServerResponse, ifFailure: self.networkErrorToResult)
                  .flatMap(ifSuccess: self.parseListingResult, ifFailure: liftError)
            )
        }
    }
    
    // MARK: - Private methods
    
    private func verifyServerResponse(_ response: (Data?, HTTPURLResponse)) -> Result<Data?, RedditError> {
        let statusCode = response.1.statusCode
        if isStatusCodeOk(statusCode) {
            return .success(response.0)
        } else {
            return .failure(.serverError(statusCode: statusCode))
        }
    }
    
    private func parseListingResult(_ data: Data?) -> Result<RedditListingResponse<RedditPostServerModel>, RedditError> {
        guard let data = data else {
            return .success(.empty())
        }

        return RedditListingResponseBuilder(data: data)
            .buildResult()
            .flatMapError { error in .failure(.parsingError(error: error)) }
    }
    
    // MARK: - Helper methods
    
    private func networkErrorToResult(_ error: NetworkError) -> Result<Data?, RedditError> {
        return .failure(.networkError(error: error))
    }
    
    private func isStatusCodeOk(_ statusCode: Int) -> Bool {
        return (200..<300).contains(statusCode)
    }
}

