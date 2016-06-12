//
//  URIConstants.swift
//  TwitterApp
//
//  Created by ishant on 13/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation

class URIConstants{
    static let BASE_URL = "https://api.twitter.com/1.1/"
    static let GET_FOLLOWERS = "friends/list.json"
    static let GET_FOLLOWING = "followers/list.json"
    static let SEARCH_TWEETS = "search/tweets.json"
    static let MARK_FAV = "favorites/create.json"
    static let RETWEET = "statuses/update.json"
    
    static let USER_TIMELINE = "statuses/user_timeline.json"
    
    class func getRetweetURL(tweetD: String) -> String{
        return "statuses/retweet/"+tweetD+".json"
    }
}