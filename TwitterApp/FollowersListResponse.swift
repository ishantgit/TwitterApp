//
//  FollowersListResponse.swift
//  TwitterApp
//
//  Created by ishant on 09/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import ObjectMapper

class FollowersListResponse: Mappable {
    
    var nextCursor: String?
    var userList:[UserModel]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userList <- map["users"]
        nextCursor <- map["next_cursor"]
    }
}