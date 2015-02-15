//
//  FilterViewController.swift
//  Yelp
//
//  Created by Hao Sun on 2/13/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterChangedDelegate: class {
    func offerDealFilterChanged(on: Bool)
    func distanceFilterChanged(distance: Double)
    func sortByFilterChanged(sortBy: Int)
    func doSearch()
}
    
class FilterViewController: UITableViewController {
    weak var delegate: FilterChangedDelegate?
    
    let distanceOptions = [1, 3, 5, 10, 25]
    let sortOptions = [0, 1, 2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func search(sender: UIBarButtonItem) {
        delegate?.doSearch()
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func offerDealChanged(sender: UISwitch) {
        delegate?.offerDealFilterChanged(sender.on)
    }
    
    @IBAction func distanceSelected(sender: UISegmentedControl) {
        let radius = distanceOptions[sender.selectedSegmentIndex]
        delegate?.distanceFilterChanged(Double(radius) * 1609.34)
    }
    
    @IBAction func sortByChanged(sender: UISegmentedControl) {
        var sortBy = sortOptions[sender.selectedSegmentIndex]
        delegate?.sortByFilterChanged(sortBy)
    }
}
