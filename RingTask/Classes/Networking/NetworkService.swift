//
//  NetworkService.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


enum NetworkError: Error, Descriptable {
    
    case unknown
    case timeOut
    case networkConnectionLost
    case cancelled
    case other(urlError: Error)
    
    init(urlError: Error?) {
        if let urlError = urlError as NSError?,
            urlError.domain == NSURLErrorDomain
        {
            switch urlError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorCannotConnectToHost,
                 NSURLErrorNetworkConnectionLost:
                self = .networkConnectionLost
            case NSURLErrorTimedOut:
                self = .timeOut
            case NSURLErrorCancelled:
                self = .cancelled
            default:
                self = .other(urlError: urlError)
            }
        } else {
            self = .unknown
        }
    }
    
    var stringDescription: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .timeOut:
            return "Timeout"
        case .networkConnectionLost:
            return "Network connection lost"
        case .cancelled:
            return "Cancelled"
        case .other(let urlError):
            return urlError.localizedDescription
        }
    }
    
}


protocol NetworkServiceProtocol {
    @discardableResult func perform(request: URLRequest,
                                    completion: @escaping (Result<(Data?, HTTPURLResponse), NetworkError>) -> Void)
        -> URLSessionDataTask
}


class NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    @discardableResult func perform(request: URLRequest,
                                    completion: @escaping (Result<(Data?, HTTPURLResponse), NetworkError>) -> Void)
        -> URLSessionDataTask
    {
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError(urlError: error)))
                return
            }
            
            completion(.success((data, response)))
        }
        dataTask.resume()
        
        return dataTask
    }
    
}
