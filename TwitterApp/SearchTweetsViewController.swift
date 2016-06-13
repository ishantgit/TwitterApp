//
//  SearchTweetsViewController.swift
//  TwitterApp
//
//  Created by ishant on 09/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit
import TwitterKit
import ObjectMapper
import Kingfisher

class SearchTweetsViewController: UITableViewController {

    
    var searchListResponse: SearchTweetResponse?
    var statusList = [Status]()
    var searchQuery: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Search", message: nil, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if textField.text!.isEmpty{
                return
            }
            self.searchListResponse = nil
            self.searchQuery = textField.text!
            self.statusList.removeAll()
            self.searchText(textField.text!)
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
   
    
    
    private func searchText(text: String){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = URIConstants.BASE_URL + URIConstants.SEARCH_TWEETS
        var params = ["q": text]
        if let response = self.searchListResponse{
            if let nextResult = response.nextResult{
                params["next_results"] = nextResult
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
                print(json)
                let responseData = Mapper<SearchTweetResponse>().map(json)
                if let listResponse = responseData{
                    self.searchListResponse = listResponse
                    if let list = listResponse.statusList{
                        self.statusList += list
                        self.tableView.reloadData()
                    }
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.statusList.count - 1{
            self.searchText(self.searchQuery!)
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTweetTableViewCell", forIndexPath: indexPath) as! SearchTweetTableViewCell
        let row = self.statusList[indexPath.row]
        cell.tweetLabel.text = row.text!
        if let user = row.tweetedBy{
            if user.screenName != nil {
                cell.screenName.text = "@\(user.screenName!)"
            }
            if let imageUrl = user.profileImageUrl{
                cell.userImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            }
        }
        cell.onFavButtonTapped = {
            self.addToFav(row.id!)
        }
        cell.onReplyButtonTapped = {
            self.getTweetText(row.id!, screenName: (row.tweetedBy?.screenName!)!)
        }
        cell.onRetweetButtonTapped = {
            self.retweetStatus(row.id!)
        }
        cell.retweetCount.text = "Retweeted \(row.retweetCount!)"
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 135.0
        return UITableViewAutomaticDimension
    }
    
    
    private func retweetStatus(tweetId: String){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = URIConstants.BASE_URL + URIConstants.getRetweetURL(tweetId)
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
        let statusesShowEndpoint = URIConstants.BASE_URL + URIConstants.MARK_FAV
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
    
    private func getTweetText(tweetId: String,screenName: String){
        let alert = UIAlertController(title: "Search", message: nil, preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.replyToTweet(tweetId, text: "@\(screenName)" + textField.text!)
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    private func replyToTweet(tweetId: String,text: String){
        let userId = NSUserDefaultUtils.retrieveStringValue(NSUserDefaultUtils.USER_ID)
        let client = TWTRAPIClient(userID: userId!)
        let statusesShowEndpoint = URIConstants.BASE_URL + URIConstants.RETWEET
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
