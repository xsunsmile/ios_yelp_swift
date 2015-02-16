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
    
    var refreshControl: UIRefreshControl!
    
    var businesses: [Business] = []
    var screenDirection = "portrait"
    var searchTerm = "Thai"
    var currentLocation = "San Francisco"
    var searchParams: NSMutableDictionary?
    var offset = 0
    var numberOfTotalResults = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        businessTableView.addSubview(refreshControl)
        
        searchParams = [
            "term": searchTerm,
            "location": currentLocation,
            "cll": "37.782193,-122.410254",
            "offset": offset
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
        SVProgressHUD.show()
        
        if let sParams = searchParams {
            client.searchWithParams(sParams, success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let businesses = response["businesses"]! as [NSDictionary]
                self.numberOfTotalResults = response["total"] as NSInteger
                
                self.businesses.removeAll(keepCapacity: true)
                for business in businesses {
                    self.businesses.append(Business(business: business as NSDictionary))
                }
                
                if let sortBy = sParams["sort"] as? Int {
                    self.businesses.sort{
                        $0.getDistance() < $1.getDistance()
                    }
                }
                
                println("reload table view")
                self.businessTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
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
        if indexPath.row < -1 {
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
    
    //    Infinite scroll
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        println("will display index \(indexPath.row), total is \(numberOfTotalResults)")
        if indexPath.row == businesses.count - 1 && offset < numberOfTotalResults - 20 {
            offset += 20
            searchParams?["offset"] = offset
            doSearch()
        }
    }
    
    func refresh() {
        println("should refresh")
        offset -= 20
        if offset < 0 {
            offset = 0
        }
        searchParams?["offset"] = offset
        refreshControl.endRefreshing()
        doSearch()
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
            searchParams?.removeObjectForKey("category_filter")
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
        println(segue.identifier)
        if segue.identifier == "FilterViewController" {
            let vc = segue.destinationViewController as FilterViewController
            vc.delegate = self
        } else if segue.identifier == "MapViewController" {
            let vc = segue.destinationViewController as MapViewController
            vc.businesses = businesses
        }
    }
}
