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
    
    fileprivate var fullScreenLoadingIndicator: UIAlertController?
    
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
        
        let longPressGesture:UILongPressGestureRecognizer =
            UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongPress))
        self.tableView.addGestureRecognizer(longPressGesture)
        
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
    
    @objc func tableViewLongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location),
              sender.state == .began else
        {
            return
        }
        
        let model = viewModel.dataSource.models[indexPath.row]
        openContextMenu(for: model)
    }
    
    
    // MARK: - Private methods
    
    private func openContextMenu(for itemModel: RedditPostServerModel) {
        let alert = UIAlertController(title: "Choose your Action",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Save attached image to gallery", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.showFullScreenLoadingIndicator()
            strongSelf.viewModel.saveImageToGallery(for: itemModel) { result in
                strongSelf.hideFullScreenLoadingIndicator(animated: false) {
                    
                    result.map(ifSuccess: { strongSelf.showFullscreenMessage("Your image was saved", duration: 2.0) },
                               ifFailure: strongSelf.handleViewModelError)
                    
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Open link", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.viewModel
                .openLink(for: itemModel)
                .mapError(strongSelf.handleViewModelError)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Loading indicators
    
    private func showFullScreenLoadingIndicator(completion: (() -> Void)? = nil) {
        if let fullScreenLoadingIndicator = fullScreenLoadingIndicator {
            fullScreenLoadingIndicator.dismiss(animated: false, completion: nil)
        }
        
        let indicator = UIAlertController(title: nil,
                                          message: "Processing...",
                                          preferredStyle: .alert)
        present(indicator, animated: true, completion: completion)
        
        fullScreenLoadingIndicator = indicator
    }
    
    private func hideFullScreenLoadingIndicator(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let fullScreenLoadingIndicator = fullScreenLoadingIndicator else {
            completion?()
            return
        }
        
        fullScreenLoadingIndicator.dismiss(animated: animated, completion: completion)
    }
    
    private func showFullscreenMessage(_ message: String, duration: TimeInterval, completion: (() -> Void)? = nil) {
        let indicator = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .alert)
        present(indicator, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            indicator.dismiss(animated: true, completion: completion)
        }
    }
    
    // MARK: - Error handlers
    
    fileprivate func handleViewModelError(_ error: RedditTopListingViewModel.Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.rawValue,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemModel = viewModel.dataSource.models[indexPath.row]
        viewModel
            .openLink(for: itemModel)
            .mapError(handleViewModelError)
    }
}


// MARK: - RedditTopListingDataSourceDelegate

extension RedditTopListingViewController: RedditTopListingDataSourceDelegate {
    
    func dataSourceDidFinishLoadingData(_ dataSource: RedditTopListingDataSource) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func dataSource(_ dataSource: RedditTopListingDataSource, didFinishWithError error: RedditError) {
        refreshControl?.endRefreshing()
        
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
