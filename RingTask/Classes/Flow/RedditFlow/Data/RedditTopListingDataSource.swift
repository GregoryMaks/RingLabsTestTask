//
//  RedditTopListingDataSource.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol RedditTopListingDataSourceDelegate: class {
    
    func dataSourceDidFinishLoadingData(_ dataSource: RedditTopListingDataSource)
    func dataSource(_ dataSource: RedditTopListingDataSource, didFinishWithError error: RedditError)
    
}


class RedditTopListingDataSource {
    
    private enum LoadingType {
        case fullReload
        case loadMore
    }
    
    // MARK: - Private properties
    
    private let redditService: RedditService
    private var isLoading = false
    private var pagingMarker: RedditPagingMarker?
    
    // MARK: - Public properties
    
    weak var delegate: RedditTopListingDataSourceDelegate?
    
    private (set) var models = [RedditPostServerModel]()
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        redditService = RedditService(networkService: networkService)
    }
    
    // MARK: - Public methods
    
    func loadData() {
        loadDataChunk(loadingType: .fullReload)
    }
    
    func loadMoreData() {
        loadDataChunk(loadingType: .loadMore)
    }
    
    // MARK: - Private methods
    
    private func loadDataChunk(loadingType: LoadingType) {
        guard !isLoading else { return }
        
        let pagingMarker: RedditPagingMarker? = (loadingType == .loadMore) ? self.pagingMarker : nil
        
        isLoading = true
        redditService.requestTopPosts(pagingMarker: pagingMarker) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let response):
                self.updateModels(withModels: response.models, shouldAppend: (loadingType == .loadMore))
                self.pagingMarker = response.pagingMarker
                
                self.isLoading = false
                self.delegate?.dataSourceDidFinishLoadingData(self)
                
            case .failure(let error):
                self.isLoading = false
                self.delegate?.dataSource(self, didFinishWithError: error)
            }
        }
    }
    
    private func updateModels(withModels newModels: [RedditPostServerModel], shouldAppend: Bool) {
        models = shouldAppend ? (models + newModels) : newModels
    }
    
}
