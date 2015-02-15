//
//  Business.swift
//  Yelp
//
//  Created by Hao Sun on 2/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Business: NSObject, Printable, DebugPrintable {
    var dictionary: NSDictionary = NSDictionary()
    
    init(business: NSDictionary) {
        super.init()
        dictionary = business
    }
    
    func getBusinessDetail(key: NSString) -> AnyObject? {
        return dictionary[key]
    }
    
    func getName() -> NSString {
        return getBusinessDetail("name") as NSString
    }
    
    func getRatingImageUrl() -> NSURL {
        return NSURL(string: getBusinessDetail("rating_img_url") as String)!
    }
    
    func getReviewCount() -> NSInteger {
        return getBusinessDetail("review_count") as NSInteger
    }
    
    func getSnippetImageUrl() -> NSURL {
        return NSURL(string: getBusinessDetail("snippet_image_url") as String)!
    }
    
    func getImageUrl() -> NSURL {
        return NSURL(string: getBusinessDetail("image_url") as String)!
    }
    
    func getLargeUrl() -> NSURL? {
        if let s = getBusinessDetail("image_url") as? String {
            return NSURL(string: s.stringByReplacingOccurrencesOfString("/ms.", withString: "/l."))
        }
        
        return nil
    }
    
    func getSnippetText() -> NSString {
        return getBusinessDetail("snippet_text") as NSString
    }
    
    func getCategories() -> NSString {
        var cate: NSMutableString = ""
        
        if let categories = getBusinessDetail("categories") as? [[NSString]] {
            for cate1 in categories {
                cate.appendString(cate1[0])
                cate.appendString(" ")
            }
        }
        
        return cate
    }
    
    func getLocation() -> NSString {
        var location: NSMutableString = ""
        
        if let loc = getBusinessDetail("location") as? NSDictionary {
            if let loc_arr = loc["address"] as? [NSString] {
                for locc in loc_arr {
                    location.appendString(locc)
                    location.appendString(", ")
                }
            }
            if let loc_city = loc["city"] as? NSString {
                location.appendString(loc_city)
            }
        }
        
        return location
    }
    
    func getGeoLocation() -> CLLocation? {
        var cloc: CLLocation?
        
        if let loc = getBusinessDetail("location") as? NSDictionary {
            if let region = loc["coordinate"] as? NSDictionary {
                let lat = region["latitude"] as Double
                let lnt = region["longitude"] as Double
                cloc = CLLocation(latitude: lat, longitude: lnt)
            }
        }
        
        return cloc
    }
    
    func getDistance() -> Double {
        let zendeskLoc = CLLocation(latitude: 37.782193, longitude: -122.410254)
        
        if let currentLocation = getGeoLocation() {
            return zendeskLoc.distanceFromLocation(currentLocation) / 1609.344
        }
        
        return 0.0
    }
    
    func getMapLocation() -> MKCoordinateRegion {
        var loc: MKCoordinateRegion?
        
        if let region = getBusinessDetail("region") as? NSDictionary {
            var region_center: CLLocationCoordinate2D?
            var region_span: MKCoordinateSpan?
            
            if let center = region["center"] as? NSDictionary {
                let lat: Double = (center["latitude"] as NSString).doubleValue
                let lnt: Double = (center["longitude"] as NSString).doubleValue
                region_center = CLLocationCoordinate2D(latitude: lat, longitude: lnt)
            }
            
            if let span = region["span"] as? NSDictionary {
                let lat: Double = (span["latitude_delta"] as NSString).doubleValue
                let lnt: Double = (span["longitude_delta"] as NSString).doubleValue
                region_span = MKCoordinateSpanMake(lat, lnt)
            }
            
            loc = MKCoordinateRegion(center: region_center!, span: region_span!)
        }
        
        return loc!
    }
    
    override var description: String {
        return dictionary.description
    }
    
    override var debugDescription: String {
        return description
    }
}
