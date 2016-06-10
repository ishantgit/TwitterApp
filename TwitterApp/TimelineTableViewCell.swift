//
//  TimelineTableViewCell.swift
//  TwitterApp
//
//  Created by ishant on 10/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

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

    @IBAction func retweetButton(sender: AnyObject) {
        if let onRetweetButtonTapped = self.onRetweetButtonTapped{
            onRetweetButtonTapped()
        }
    }
    
    @IBAction func favTweetButton(sender: AnyObject) {
        if let onFavButtonTapped = self.onFavButtonTapped{
            onFavButtonTapped()
        }
    }
    @IBAction func replyTweetButton(sender: AnyObject) {
        if let onReplyButtonTapped = self.onReplyButtonTapped{
            onReplyButtonTapped()
        }
    }
}
