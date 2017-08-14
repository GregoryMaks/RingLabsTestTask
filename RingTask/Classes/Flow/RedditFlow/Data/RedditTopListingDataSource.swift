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
    func dataSource(_ dataSource: RedditTopListingDataSource, didFinishWithError error: RedditService.RedditError)
    
}


class RedditTopListingDataSource {
    
    private enum LoadingType {
        case fullReload
        case loadMore
    }
    
    // MARK: - Private properties
    
    private let redditService: RedditService
    private var isLoading = false
    private var pagingMarker: RedditListingResponse<RedditPostServerModel>.PagingMarker?
    
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
        
        redditService.requestTopPosts { result in
            result.analysis(ifValue:
                { [weak self] response in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.modifyModels(withNewData: response.models, append: (loadingType == .loadMore))
                    strongSelf.pagingMarker = response.pagingMarker
                    
                    strongSelf.isLoading = false
                    strongSelf.delegate?.dataSourceDidFinishLoadingData(strongSelf)
                }, ifError:
                { [weak self] error in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.isLoading = false
                    strongSelf.delegate?.dataSource(strongSelf, didFinishWithError: error)
                }
            )
        }
    }
    
    private func modifyModels(withNewData newModels: [RedditPostServerModel], append: Bool) {
        models = append ? (models + newModels) : newModels
    }
    
}