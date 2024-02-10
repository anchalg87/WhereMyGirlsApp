//
//  GetLocation.swift
//  WMGA
//
//  Created by Capstone on 7/24/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GetLocation: UIViewController, CLLocationManagerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [MKPointAnnotation]()
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        
        // Also add to our map so we can remove old values later
        locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            
            locations.removeAtIndex(0)
            NSLog("****Location in GetLocation***")
            NSLog("%@", newLocation)
            
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
