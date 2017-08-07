//
//  RedditService.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation

class RedditService {

    enum RedditError: Error {
        case networkError(error: NetworkError)
        case serverError(statusCode: Int)
        case parsingError(error: ParsingError)
    }
    
    private struct Constants {
        static let apiUrl = "api.reddit.com"
        
        static var topPostsAbsoluteURL: URL {
            return URL(string: "/top", relativeTo: URL(string: apiUrl)!)!
        }
    }
    
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
    init(networkService: NetworkServiceProtocol, queue: DispatchQueue = DispatchQueue.main) {
        self.networkService = networkService
        self.queue = queue
    }
    
    func requestTopPosts(completion: @escaping (Result<[RedditPostModel], RedditError>) -> Void) {
        let request = URLRequest(url: Constants.topPostsAbsoluteURL)
        networkService.perform(request: request) {
            completion(
                $0.flatMap(ifSuccess: self.verifyServerResponse, ifFailure: self.networkErrorToResult)
                  .flatMap(ifSuccess: self.parsePostModels, ifFailure: liftError)
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
    
    private func parsePostModels(_ data: Data?) -> Result<[RedditPostModel], RedditError> {
        guard let data = data else {
            return .success([])
        }
    
        let builder = RedditPostModelBuilder(data: data)
        return builder.buildModels().flatMapError(transform: { return .failure(.parsingError(error: $0)) })
    }
    
    // MARK: - Helper methods
    
    private func networkErrorToResult(_ error: NetworkError) -> Result<Data?, RedditError> {
        return .failure(.networkError(error: error))
    }
    
    private func isStatusCodeOk(_ statusCode: Int) -> Bool {
        return (200..<300).contains(statusCode)
    }
}
