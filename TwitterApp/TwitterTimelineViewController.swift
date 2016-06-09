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
        
        self.showHomeTwitter()
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
    
    func getHomeTimeLine() {
        var clientError:NSError?
        let params: Dictionary = Dictionary<String, String>()
        
        let request: NSURLRequest! = TWTRAPIClient().URLRequestWithMethod(
            "GET",
            URL: "https://api.twitter.com/1.1/statuses/home_timeline.json",
            parameters: params,
            error: &clientError)
        
        if request != nil {
            TWTRAPIClient().sendTwitterRequest(request!) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    if data != nil{
                        print(data)
                    }
                }
                else {
                    print("Error: \(connectionError)")
                }
            }
        }
        else {
            print("Error: \(clientError)")
        }
    }
    
    private func showHomeTwitter(){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
        let params = ["user_id": userId!]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
