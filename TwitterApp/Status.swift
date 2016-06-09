
//
//  Status.swift
//  TwitterApp
//
//  Created by ishant on 09/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import ObjectMapper

class Status: Mappable {
    
    var id:String?
    var text:String?
    var retweetCount: Int?
    var tweetedBy: UserModel?
    var replyToUserId: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id_str"]
        tweetedBy <- map["user"]
        text <- map["text"]
        retweetCount <- map["retweet_count"]
        replyToUserId <- map["in_reply_to_user_id_str"]
    }
}