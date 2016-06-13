//
//  SearchTweetTableViewCell.swift
//  TwitterApp
//
//  Created by ishant on 13/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit

class SearchTweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    var onRetweetButtonTapped: (() -> Void)? = nil
    var onFavButtonTapped: (() ->Void)? = nil
    var onReplyButtonTapped: (() -> Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func retweetTapped(sender: AnyObject) {
        if let onRetweetButtonTapped = self.onRetweetButtonTapped{
            onRetweetButtonTapped()
        }
    }

    @IBAction func onReplyButtonTapped(sender: AnyObject) {
        if let onReplyButtonTapped = self.onReplyButtonTapped{
            onReplyButtonTapped()
        }
    }
    @IBAction func onFavButtonTapped(sender: AnyObject) {
        if let onFavButtonTapped = self.onFavButtonTapped{
            onFavButtonTapped()
        }
    }
}
