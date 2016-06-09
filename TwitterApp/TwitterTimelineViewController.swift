//
//  TwitterTimelineViewController.swift
//  TwitterApp
//
//  Created by ishant on 08/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

class TwitterTimelineViewController: TWTRTimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TimeLine"
        let client = TWTRAPIClient()
        //let session = Twitter.sharedInstance()
        let userName = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_NAME)
        self.dataSource = TWTRUserTimelineDataSource(screenName: userName!, APIClient: client)
        
        // Do any additional setup after loading the view.
    }
    
    private func loadUser(){
        let client = TWTRAPIClient()
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        client.loadUserWithID(userId!) { (user, error) -> Void in
            // handle the response or error
            if let userModel = user{
                print(userModel)
            }
        }
    }
    
    
    
    private func presentLoginController(){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController{
            self.showDetailViewController(vc, sender: nil)
        }
    }

    @IBAction func postTweetTapped(sender: AnyObject) {
        let composer = TWTRComposer()
    
        composer.setText("")
        
        // Called from a UIViewController
        composer.showFromViewController(self) { result in
            if result == TWTRComposerResult.Cancelled {
                print("Tweet composition cancelled")
            }
            else if result == TWTRComposerResult.Done{
                self.refresh()
            }
            else {
                print("Sending tweet!")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
