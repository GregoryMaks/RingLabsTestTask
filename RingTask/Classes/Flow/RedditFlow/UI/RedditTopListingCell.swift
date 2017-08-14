//
//  RedditTopListingCell.swift
//  RingTask
//
//  Created by Gregory on 8/13/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class RedditTopListingCell: UITableViewCell, NibLoadableView, Reusable {
    
//    struct Model {
//        let title: String
//        let author: String
//        let createdAt: Date
//        let commentsCount: Int
//        let thumbnailUrl: URL?
//        
//        init(serverModel: RedditPostServerModel) {
//            title = serverModel.title
//            author = serverModel.author
//            createdAt = serverModel.createdAt
//            commentsCount = serverModel.commentsCount
//            thumbnailUrl = serverModel.thumbnailUrl
//        }
//    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorDateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    // MARK: - Public properties
    
    var model: RedditPostServerModel? {
        didSet {
            updateContent()
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        model = nil
    }
    
    // MARK: - Public methods
    
    func startLoadingImage() {
        imageActivityIndicator.isHidden = false
        imageActivityIndicator.startAnimating()
    }
    
    func cancelLoadingOperations() {
        imageActivityIndicator.isHidden = true
        imageActivityIndicator.stopAnimating()
    }
    
    // MARK: - Private methods
    
    private func updateContent() {
        guard let model = model else {
            thumbnailImageView.image = UIImage(named: "NoThumbnail")
            imageActivityIndicator.isHidden = true
            titleLabel.text = nil
            authorDateLabel.text = nil
            commentsLabel.text = nil
            return
        }
        
        titleLabel.text = model.title
        authorDateLabel.text = AuthorDateFormatter().authorDateString(forAuthor: model.author, date: model.createdAt)
        commentsLabel.text = CommentFormatter().commentString(fromCommentCount: model.commentsCount)
    }
    
}
