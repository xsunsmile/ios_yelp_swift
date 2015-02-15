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
                              UISearchBarDelegate,
                              FilterChangedDelegate
{
    var client: YelpClient!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var businessTableView: UITableView!
    
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    var businesses: [Business] = []
    var screenDirection = "portrait"
    var searchTerm = "Thai"
    var currentLocation = "San Francisco"
    var searchParams: NSMutableDictionary?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchParams = [
            "term": searchTerm,
            "location": currentLocation,
            "cll": "37.782193,-122.410254",
        ]
        var searchBarHeight = navigationController?.navigationBar.frame.height
        var searchBar = UISearchBar(frame: CGRectMake(0, 0, view.frame.size.width * 0.8, searchBarHeight! * 0.6))
        searchBar.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        navigationItem.titleView = searchBar
        
        businessTableView.delegate = self
        businessTableView.dataSource = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 90
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        doSearch()
    }
    
    func doSearch() {
        businesses.removeAll(keepCapacity: true)
        SVProgressHUD.show()
        
        if let sParams = searchParams {
            client.searchWithParams(sParams, success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let businesses = response["businesses"]! as [NSDictionary]
                for business in businesses {
                    self.businesses.append(Business(business: business as NSDictionary))
                }
                
                if let sortBy = sParams["sort"] as? Int {
                    self.businesses.sort{
                        $0.getDistance() < $1.getDistance()
                    }
                }
                
                self.businessTableView.reloadData()
                SVProgressHUD.dismiss()
                
                }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println(error)
                    SVProgressHUD.dismiss()
            }
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        }
        searchTerm = searchText
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchTerm.isEmpty {
            searchBar.endEditing(true)
            searchBar.text = ""
            searchParams?.removeObjectForKey("sort")
            searchParams?.removeObjectForKey("radius_filter")
            searchParams?.removeObjectForKey("deals_filter")
            searchParams?["term"] = searchTerm
            doSearch()
        }
    }
    
    func distanceFilterChanged(distance: Double) {
        searchParams?["radius_filter"] = distance
    }
    
    func offerDealFilterChanged(on: Bool) {
        searchParams?["deals_filter"] = on
    }
    
    func sortByFilterChanged(sortBy: Int) {
        searchParams?["sort"] = sortBy
    }
    
    func categoryFilterChanged(category: NSString) {
        searchParams?["category_filter"] = category
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FilterViewController" {
            let vc = segue.destinationViewController as FilterViewController
            vc.delegate = self
        }
    }
}
