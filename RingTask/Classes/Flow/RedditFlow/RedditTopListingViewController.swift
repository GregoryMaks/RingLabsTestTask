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
    
    var viewModel: RedditTopListingViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cell: RedditTopListingCell.self)
        tableView.estimatedRowHeight = 87.0
        
        viewModel.dataSource.loadData()
    }
    
    // MARK: - Public methods
    
    func bind(viewModel: RedditTopListingViewModel) {
        self.viewModel = viewModel
        self.viewModel.dataSource.delegate = self
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
    
}


// MARK: - UITableViewDelegate

extension RedditTopListingViewController {

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath)
    {
        (cell as? RedditTopListingCell).flatMap {
            $0.startLoadingImage()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didEndDisplaying cell: UITableViewCell,
                            forRowAt indexPath: IndexPath)
    {
        (cell as? RedditTopListingCell).flatMap {
            $0.cancelLoadingOperations()
        }
    }
    
}


extension RedditTopListingViewController: RedditTopListingDataSourceDelegate {
    
    func dataSourceDidFinishLoadingData(_ dataSource: RedditTopListingDataSource) {
        tableView.reloadData()
    }
    
    func dataSource(_ dataSource: RedditTopListingDataSource, didFinishWithError error: RedditService.RedditError) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertControllerStyle.alert)
        present(alert, animated: true, completion: nil)
    }
    
}
