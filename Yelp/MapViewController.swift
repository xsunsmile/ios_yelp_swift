//
//  MapViewController.swift
//  Yelp
//
//  Created by Hao Sun on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,
                         MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        zoomToCurrentLocation()
        placeBusinesses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func zoomToCurrentLocation() {
        let center = CLLocationCoordinate2D(latitude: 37.782193, longitude: -122.410254)
        let region = MKCoordinateRegionMakeWithDistance(center, 2000, 2000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Your Location"
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func placeBusinesses() {
        if mapView == nil || businesses.count == 0 {
            return
        }
        
        for business in businesses {
            let coord = business.getCoordinates()
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = business.getName()
            annotation.subtitle = business.getLocation()
            mapView.addAnnotation(annotation)
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
