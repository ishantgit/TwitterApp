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
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func followersButtonTapped(sender: AnyObject) {
        
    }

    @IBAction func followingButtonTapped(sender: AnyObject) {
        
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
