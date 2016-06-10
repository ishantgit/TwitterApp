//
//  UserModel.swift
//  TwitterApp
//
//  Created by ishant on 09/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: Mappable{
    
    var id: String?
    var name:String?
    var screenName:String?
    var location: String?
    var friendsCount:Int?
    var followersCount: Int?
    var profileImageUrl: String?
    var followingCount: Int?
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id_str"]
        name <- map["name"]
        screenName <- map["screen_name"]
        location <- map["location"]
        followersCount <- map["followers_count"]
        friendsCount <- map["friends_count"]
        profileImageUrl <- map["profile_image_url"]
        followingCount <- map["friends_count"]
    }
}