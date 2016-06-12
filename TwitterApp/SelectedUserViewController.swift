//
//  SelectedUserViewController.swift
//  TwitterApp
//
//  Created by ishant on 10/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit
import TwitterKit
import ObjectMapper
import Kingfisher

class SelectedUserViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followersButton: UIButton!

    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var selectedUser: UserModel?
    var tweetList = [Status]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = self.selectedUser{
            self.navigationItem.title = user.name!
            self.userName.text = user.name!
            self.userScreenName.text  = "@\(user.screenName!)"
            if let followers = user.followersCount{
                self.followersButton.titleLabel?.text = "\(followers) Followers"
            }
            if let followers = user.followingCount{
                self.followersButton.titleLabel?.text = "\(followers) Followers"
            }
            if let imageURL = user.profileImageUrl{
                self.userImage.kf_setImageWithURL(NSURL(string: imageURL)!)
            }
        }
        
        self.getUserDetail()
        // Do any additional setup after loading the view.
    }
    
    func getUserDetail(){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        var params = [String:AnyObject]()
        if let user = self.selectedUser{
            params["user_id"] =  user.id!
        }else{
            return
        }
        var clientError : NSError?
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                self.tweetList = Mapper<Status>().mapArray(json)!
                self.tableView.reloadData()
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 77.0
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TimelineTableViewCell", forIndexPath: indexPath) as! TimelineTableViewCell
        let row = self.tweetList[indexPath.row]
        cell.tweetLabel.text = row.text!
        cell.onFavButtonTapped = {
            self.addToFav(row.id!)
        }
        cell.onRetweetButtonTapped = {
            self.retweetStatus(row.id!)
        }
        cell.onReplyButtonTapped = {
            self.getTweetText(row.id!)
        }
        return cell
    }
    
    private func retweetStatus(tweetId: String){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/retweet/"+tweetId+".json"
        let params = [String: AnyObject]()
        var clientError : NSError?
        let request = client.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                if data != nil {
                    print("retweeted")
                    print(response)
                }else{
                    print("data is nil")
                }
            }
        }
    }
    
    private func addToFav(tweetId: String){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/create.json"
        let params = ["id": tweetId]
        var clientError : NSError?
        let request = client.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                if data != nil {
                    print("added to fav list")
                }else{
                    print("data is nil")
                }
            }
        }

    }
    
    private func getTweetText(tweetId: String){
        let alert = UIAlertController(title: "Search", message: nil, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.replyToTweet(tweetId, text: textField.text!)
    
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    private func replyToTweet(tweetId: String,text: String){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/update.json"
        var params = [String:AnyObject]()
        params["status"] = text
        params["in_reply_to_status_id"] = tweetId
        var clientError : NSError?
        let request = client.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                if data != nil {
                    print("added to fav list")
                }else{
                    print("data is nil")
                }
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func followersButtonTapped(sender: AnyObject) {
        
    }

    @IBAction func followingButtonTapped(sender: AnyObject) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showFollowers"{
            if let controller = segue.destinationViewController as? UserFollowersTableViewController{
                controller.userModel = self.selectedUser
                controller.showFollowers = true
            }
        }
        else if segue.identifier == "showFollowing"{
            if let controller = segue.destinationViewController as? UserFollowersTableViewController{
                controller.userModel = self.selectedUser
                controller.showFollowers = false
            }
        }
    }
 

}
