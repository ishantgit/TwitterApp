//
//  ViewController.swift
//  TwitterApp
//
//  Created by ishant on 07/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if checkUserLogin(){
            self.moveToTimeLine()
        }
        self.navigationItem.title = "TimeLine"
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                NSUserDefaultUtils.storeStringValue(unwrappedSession.authToken, forKey: NSUserDefaultUtils.ACCESS_TOKEN)
                NSUserDefaultUtils.storeStringValue(unwrappedSession.authTokenSecret, forKey: NSUserDefaultUtils.TWITTER_SECRET)
                NSUserDefaultUtils.storeStringValue(unwrappedSession.userName, forKey: NSUserDefaultUtils.USER_NAME)
                NSUserDefaultUtils.storeStringValue(unwrappedSession.userID, forKey: NSUserDefaultUtils.USER_ID)
                self.moveToTimeLine()
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func checkUserLogin() -> Bool{
        guard NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.ACCESS_TOKEN) != nil else{
            return false
        }
        guard NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.TWITTER_SECRET) != nil else{
            return false
        }
        guard NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID) != nil else{
            return false
        }
        guard NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_NAME) != nil else{
            return false
        }
        return true
        
    }
    
    private func moveToTimeLine(){
        self.performSegueWithIdentifier("showTimeline", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

