//
//  MemberLocationViewController.swift
//  WMGA
//
//  Created by Capstone on 7/22/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MemberLocationViewController: UIViewController, CLLocationManagerDelegate {
    
     var latitude:Double = 0.0
     var longitude:Double = 0.0
    
    var latandlong = [String]()
    var details = [String]()
    var uname:String!
    var gname:String!
   
    
    var annotation:MKPointAnnotation!
    var allannotation:MKPointAnnotation!
    var AllLocations = [MKPointAnnotation]()
    var locationTimer = NSTimer()
    
    
    @IBOutlet weak var stopTracking: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var startTracking: UIButton!
   
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
        
    
    
    @IBAction func trackUserLocation(sender: AnyObject) {
        
        
            startTracking.enabled = false
            stopTracking.enabled = true
        
            if(uname != "All Members")
            {
        
            locationTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "continueTracking", userInfo: nil, repeats: true)
        }
        else
            {
                 locationTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "continueTrackingOfAll", userInfo: nil, repeats: true)
        }
        
    
        
    }
    
    
    @IBAction func stopTracking(sender: AnyObject) {
        startTracking.enabled = true
        stopTracking.enabled = false
        locationTimer.invalidate()
        
        
    }
    func addAnnotation(coordinate:CLLocationCoordinate2D, title:String, subtitle:String)
    {
        annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapview.addAnnotation(annotation)
    }
    
    func continueTracking()
    {
        
        
        if(annotation != nil)
        {
            mapview.removeAnnotation(annotation)
        }
       
       
        let request2 = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getCurrentLocation.php")!)
        request2.HTTPMethod = "POST"
        let postString1 = "uname=\(uname)"
        
        request2.HTTPBody = postString1.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request2)
        {
            data1,response1,error1 in
            if error1 != nil{
                print("error = \(error1)")
                return
            }
            let strData1 = NSString(data: data1!, encoding: NSUTF8StringEncoding)
            print("Lat and Long Data: \(strData1)")
            
            
            do {
                
                
                let myJSON1 =  try NSJSONSerialization.JSONObjectWithData(data1!, options: .MutableContainers) as? NSDictionary
                
                print(myJSON1)
                self.latitude = Double((myJSON1?.valueForKey("1"))! as! String)!
                self.longitude =  Double((myJSON1?.valueForKey("2"))! as! String)!
                
                
                
                // This will execute after loaded the data so must use dispatch
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latitude, self.longitude)
                    
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    
                    self.addAnnotation(location, title: self.uname, subtitle: "Current Location")
                    self.mapview.setRegion(region, animated: true)
                    
                });
                
                
                
            } catch {
                print(error)
            }
            
        } // close of task 1
        
        task1.resume()
        
    }
    
    
    // add annotation for all members
    
    func addAnnotationForAll(coordinate:CLLocationCoordinate2D, title:String, subtitle:String)
    {
        allannotation = MKPointAnnotation()
        allannotation.coordinate = coordinate
        allannotation.title = title
        allannotation.subtitle = subtitle
        AllLocations.append(allannotation)
        
    }
    
    
    
    
    // Continue tracking of all members
    
    func continueTrackingOfAll()
    {
        self.AllLocations = [MKPointAnnotation]()
        AllLocations.removeAll()
        latandlong = [String]()
        latandlong.removeAll()
      
        if(AllLocations .isEmpty)
        {
            
            mapview.removeAnnotations(mapview.annotations)
        }
        
        
        let request2 = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getCurrentLocationOfAll.php")!)
        request2.HTTPMethod = "POST"
        let postString1 = "gname=\(gname)"
        
        request2.HTTPBody = postString1.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request2)
        {
            data1,response1,error1 in
            if error1 != nil{
                print("error = \(error1)")
                return
            }
            let strData1 = NSString(data: data1!, encoding: NSUTF8StringEncoding)
            print("Lat and Long Data: \(strData1)")
            
            
            do {
                
                
                let myJSON1 =  try NSJSONSerialization.JSONObjectWithData(data1!, options: .MutableContainers) as? NSDictionary
                
                print(myJSON1)
                var i = 1
                while i <= myJSON1?.count {
                    self.latandlong.append((myJSON1?.valueForKey("\(i)"))! as! String)
                    i += 1
                }

                
                
                
                // This will execute after loaded the data so must use dispatch
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    var j=0
                    var region:MKCoordinateRegion!
                    var location:CLLocationCoordinate2D!
                    var span:MKCoordinateSpan!
                    while(j<self.latandlong.count)
                    {
                      
                       self.details = self.latandlong[j].componentsSeparatedByString(",")
                        let uemail = self.details[0]
                        let ulat = Double(self.details[1])
                        let ulong = Double(self.details[2])
                        
                        location = CLLocationCoordinate2DMake(ulat!, ulong!)
                        
                        span = MKCoordinateSpanMake(0.1, 0.1)
                        region = MKCoordinateRegionMake(location, span)
                        self.addAnnotationForAll(location, title: uemail, subtitle: "Current Location")
                       
                        j += 1
                        
                    }
                    
                    self.mapview.addAnnotations(self.AllLocations)
                     self.mapview.setRegion(region, animated: true)
                    self.mapview.showAnnotations(self.AllLocations, animated: true)
                   
                    
                });
                
                
                
            } catch {
                print(error)
            }
            
        } // close of task 1
        
        task1.resume()
        
    }

    
    
    
    }





