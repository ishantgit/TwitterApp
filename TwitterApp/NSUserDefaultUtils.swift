//
//  NSUserDefaultUtils.swift
//  TwitterApp
//
//  Created by ishant on 08/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation

class NSUserDefaultUtils{
    static let TWITTERAPP = "twitter_app"
    static let ACCESS_TOKEN = "access_token"
    static let TWITTER_SECRET = "twitter_secret"
    static let USER_ID = "user_id"
    static let USER_NAME = "user_name"
    
    
    //single private instance of { NSUserDefaults }
    private static let nsUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private init(){
        //To prevent initialising
    }
    
    class func storeStringValue(value: String?, forKey defaultName: String){
        objc_sync_enter(nsUserDefaults)
        nsUserDefaults.setObject(value, forKey: defaultName)
        objc_sync_exit(nsUserDefaults)
    }
    
    
    // returns the String if the key existed, or nil if not.
    class func retrieveStringValue(key: String) -> String? {
        if let value = nsUserDefaults.objectForKey(key) as? String {
            return value
        }
        return nil
    }
    
    class func storeIntegerValue(value: Int, forKey defaultName: String){
        objc_sync_enter(nsUserDefaults)
        nsUserDefaults.setInteger(value, forKey: defaultName)
        objc_sync_exit(nsUserDefaults)
    }
    
    // returns an integer if the key existed, or 0 if not.
    class func retrieveIntegerValue(key: String) -> Int {
        return nsUserDefaults.integerForKey(key)
    }
    
    
    
    class func storeBooleanValue(value: Bool, forKey defaultName: String){
        objc_sync_enter(nsUserDefaults)
        nsUserDefaults.setBool(value, forKey: defaultName)
        objc_sync_exit(nsUserDefaults)
    }
    
    // returns a boolean if the key existed, or false if not
    class func retrieveBooleanValue(key: String) -> Bool {
        return nsUserDefaults.boolForKey(key)
    }
    
    class func deleteUserDefaults(){
        objc_sync_enter(nsUserDefaults)
        for key in Array(nsUserDefaults.dictionaryRepresentation().keys){
            nsUserDefaults.removeObjectForKey(key)
        }
        objc_sync_exit(nsUserDefaults)
    }

}