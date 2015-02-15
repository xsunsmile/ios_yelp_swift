//
//  BusinessCell.swift
//  Yelp
//
//  Created by Hao Sun on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business? {
        didSet {
            refreshView()
        }
    }
    
    func refreshView() {
        nameLabel.text = business!.getName()
        reviewsLabel.text = NSString(format: "%d reviews", business!.getReviewCount())
        categoryLabel.text = business!.getCategories()
        addressLabel.text = business!.getLocation()
        distanceLabel.text = NSString(format: "%.1f mi", business!.getDistance())
        businessIcon.setImageWithURL(business!.getImageUrl())
        ratingImageView.setImageWithURL(business!.getRatingImageUrl())
    }
    
    override func layoutSubviews() {
        refreshView()
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
