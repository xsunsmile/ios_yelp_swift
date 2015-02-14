//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Hao Sun on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController,
                              UITableViewDelegate,
                              UITableViewDataSource,
                              UISearchBarDelegate
{
    var client: YelpClient!
    
    @IBOutlet weak var businessTableView: UITableView!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    var businesses: [Business] = []
    var screenDirection = "portrait"
    var searchTerm = "Thai"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        var searchBar = UISearchBar(frame: CGRectMake(0, 0, view.frame.size.width * 0.8, 40))
        searchBar.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        navigationItem.titleView = searchBar
        
        businessTableView.delegate = self
        businessTableView.dataSource = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 90
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        SVProgressHUD.show()
        doSearch(searchTerm)
        SVProgressHUD.dismiss()
    }
    
    func doSearch(term: NSString) {
        businesses.removeAll(keepCapacity: true)
        
        client.searchWithTerm(term, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let businesses = response["businesses"]! as [NSDictionary]
            for business in businesses {
                self.businesses.append(Business(business: business as NSDictionary))
            }
            
            self.businessTableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row > -1 {
            let id = "FeaturedBusinessCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(id) as FeaturedBusinessCell
            cell.business = businesses[indexPath.row]
            return cell
        } else {
            let id = "BusinessCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(id) as BusinessCell
            cell.business = businesses[indexPath.row]
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            screenDirection = "landscape"
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            screenDirection = "portrait"
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        } else {
            searchTerm = searchText
            println(searchTerm)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search \(searchTerm)")
        if !searchTerm.isEmpty {
            searchBar.endEditing(true)
            searchBar.text = ""
            doSearch(searchTerm)
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
