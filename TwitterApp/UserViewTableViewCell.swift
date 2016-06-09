//
//  UserViewTableViewCell.swift
//  TwitterApp
//
//  Created by ishant on 09/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit

class UserViewTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var friendsCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
