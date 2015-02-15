//
//  FeaturedBusinessCell.swift
//  Yelp
//
//  Created by Hao Sun on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FeaturedBusinessCell: UITableViewCell {

    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var snippetImageView: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var business: Business? {
        didSet {
            nameLabel.text = business!.getName()
            reviewLabel.text = NSString(format: "%d reviews", business!.getReviewCount())
            categoryLabel.text = business!.getCategories()
            distanceLabel.text = NSString(format: "%.1f mi", business!.getDistance())
            featuredImageView.setImageWithURL(business!.getLargeUrl())
            ratingImageView.setImageWithURL(business!.getRatingImageUrl())
            snippetImageView.setImageWithURL(business!.getSnippetImageUrl())
            snippetLabel.text = business!.getSnippetText()
            addressLabel.text = business!.getLocation()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
