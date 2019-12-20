//
//  RedditService.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


enum RedditError: Error, Descriptable {
    case networkError(error: NetworkError)
    case serverError(statusCode: Int)
    case parsingError(error: ParsingError)
    
    var stringDescription: String {
        switch self {
        case .networkError(let networkError):
            return "Network error: \(networkError.stringDescription)"
        case .serverError(let statusCode):
            return "Server error \(statusCode)"
        case .parsingError(let parsingError):
            return "Parsing error: \(parsingError.stringDescription)"
        }
    }
}


class RedditService {

    // MARK: - Subtypes
    
    private struct Constants {
        static let apiUrl = URL(string: "https://api.reddit.com")!
        
        static var topPostsAbsoluteURL: URL {
            return URL(string: "top", relativeTo: apiUrl)!
        }
    }
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, queue: DispatchQueue = .main) {
        self.networkService = networkService
        self.queue = queue
    }
    
    func requestTopPosts(pagingMarker: RedditPagingMarker?,
                         completion: @escaping (Result<RedditListingResponse<RedditPostServerModel>, RedditError>) -> Void)
    {
        let query = pagingMarker.flatMap { "after=\($0.after)" } ?? ""
        let url = Constants.topPostsAbsoluteURL.urlWith(query: query)!
        
        let request = URLRequest(url: url)
        networkService.perform(request: request) { [weak self] result in
            guard let `self` = self else { return }
            self.queue.async {
                completion(
                    result.flatMapBoth(ifSuccess: self.verifyServerResponse, ifFailure: self.networkErrorToResult)
                          .flatMapBoth(ifSuccess: self.parseListingResult, ifFailure: liftError)
                )
            }
        }
    }
    
    // MARK: - Private methods
    
    private func verifyServerResponse(_ response: (data: Data?, urlResponse: HTTPURLResponse))
        -> Result<Data?, RedditError>
    {
        if HttpStatus(response.urlResponse).isOk {
            return .success(response.0)
        } else {
            return .failure(.serverError(statusCode: response.urlResponse.statusCode))
        }
    }
    
    private func parseListingResult(_ data: Data?)
        -> Result<RedditListingResponse<RedditPostServerModel>, RedditError>
    {
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

}

