//
//  UserFollowersTableViewController.swift
//  TwitterApp
//
//  Created by ishant on 10/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit
import TwitterKit
import ObjectMapper

class UserFollowersTableViewController: UITableViewController {

    var showFollowers: Bool?
    var userModel: UserModel?
    var userId: String?
    
    var userListResponse: FollowersListResponse?
    var userList = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = self.userModel{
            self.userId = user.id!
            self.navigationItem.title = user.name!
            self.getList()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    private func getList(){
        let userID = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userID!)
        var statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
        if let showFollowerType = self.showFollowers{
            if showFollowerType{
                statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
            }else{
                statusesShowEndpoint = "https://api.twitter.com/1.1/friends/list.json"
            }
        }
        
        var params = ["user_id": self.userId!]
        if let response = self.userListResponse{
            if let cursor = response.nextCursor{
                params["cursor"] = cursor
            }else{
                return
            }
        }
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let responseData = Mapper<FollowersListResponse>().map(json)
                if let userResponse = responseData{
                    self.userListResponse = userResponse
                    if let list = userResponse.userList{
                        self.userList += list
                        self.tableView.reloadData()
                    }
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row  == self.userList.count - 1{
            self.getList()
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("UserViewTableViewCell", forIndexPath: indexPath) as! UserViewTableViewCell
        let row = userList[indexPath.row]
        cell.userName.text = row.name!
        cell.userScreenName.text = "@\(row.screenName!)"
        cell.followersCount.text =  "\(row.followersCount!) Followers"
        cell.friendsCount.text = "\(row.friendsCount!) Following"
        if let imageURL = row.profileImageUrl{
            cell.userImage.kf_setImageWithURL(NSURL(string: imageURL)!)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 135.0
        return UITableViewAutomaticDimension
    }
    
    

}
