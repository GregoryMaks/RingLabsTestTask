//
//  RedditTopListingViewController.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/7/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class RedditTopListingViewController: UITableViewController {
    
    // MARK: - Private properties
    
    fileprivate var viewModel: RedditTopListingViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cell: RedditTopListingCell.self)
        tableView.register(headerFooterView: LoadMoreFooterView.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 87.0 // not a magic number, used by TV to approximate
        
        tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionFooterHeight = 45.0   // not a magic number, used by TV to approximate
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        
        
        viewModel.dataSource.loadData()
    }
    
    // MARK: - Public methods
    
    func bind(viewModel: RedditTopListingViewModel) {
        self.viewModel = viewModel
        viewModel.dataSource.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        viewModel.dataSource.loadData()
    }
    
}


// MARK: - UITableViewDataSource

extension RedditTopListingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RedditTopListingCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = viewModel.dataSource.models[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.models.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Hide header
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView() as LoadMoreFooterView
    }
    
}


// MARK: - UITableViewDelegate

extension RedditTopListingViewController {

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath)
    {
        (cell as? RedditTopListingCell).flatMap {
            $0.startLoadingImage(imageLoadingService: self.viewModel.imageLoadingService)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didEndDisplaying cell: UITableViewCell,
                            forRowAt indexPath: IndexPath)
    {
        (cell as? RedditTopListingCell).flatMap {
            $0.cancelImageLoading()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        viewModel.dataSource.loadMoreData()
    }
    
}


extension RedditTopListingViewController: RedditTopListingDataSourceDelegate {
    
    func dataSourceDidFinishLoadingData(_ dataSource: RedditTopListingDataSource) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func dataSource(_ dataSource: RedditTopListingDataSource, didFinishWithError error: RedditError) {
        refreshControl?.endRefreshing()
        
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
