//
//  NetworkService.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    
    case unknown
    case timeOut
    case networkConnectionLost
    case cancelled
    case other(urlError: Error)
    
    init(urlError: Error?) {
        // TODO
        if let urlError = urlError {
            self = .other(urlError: urlError)
        } else {
            self = .unknown
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
