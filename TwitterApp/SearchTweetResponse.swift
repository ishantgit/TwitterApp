//
//  SearchTweetResponse.swift
//  TwitterApp
//
//  Created by ishant on 09/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchTweetResponse: Mappable {
    
    var statusList: [Status]?
    var nextResult: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        statusList <- map["statuses"]
        nextResult <- map["next_results"]
    }
}