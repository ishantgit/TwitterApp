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
        if checkUserLogin(){
            let client = TWTRAPIClient()
            //let session = Twitter.sharedInstance()
            let userName = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_NAME)
            self.dataSource = TWTRUserTimelineDataSource(screenName: userName!, APIClient: client)
        }else{
            self.presentLoginController()
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func presentLoginController(){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController{
            self.presentViewController(vc, animated: false, completion: nil)
        }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
