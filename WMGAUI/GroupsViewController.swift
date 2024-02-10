    //
    //  GroupsViewController.swift
    //  WMGA
    //
    //  Created by  on 6/23/16.
    //  Copyright © 2016 uhcl. All rights reserved.
    //

    import UIKit
    import CoreData
    import CoreLocation
    import MapKit


    var selectedgroup:String!  // Selected group name from table
    class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate
    {
        // Outlets and Actions
        
        @IBOutlet var tableview: UITableView!
        // Variables
        var array = [String]()
        var defaults = NSUserDefaults.standardUserDefaults()
        var status:String? // status of url
        var pwdstatus:String? // status of pwd
        var uname:String!
        var message:String!
        var gname = [String]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            uname = defaults.stringForKey("username")!
             locationManager.startUpdatingLocation()
            
            
            
            
            
            
        }
        
        
        override func viewWillAppear(animated: Bool) {
            array.removeAll()
            
            
            
            // get badge for notifications
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getnotificationscount.php")!)
            request.HTTPMethod = "POST"
            let postString = "uname=\(uname)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data,response,error in
                if error != nil{
                    print("error = \(error)")
                    return
                }
                
                
                do {
                    let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    if let parseJSON = myJSON {
                        
                        // Now we can access value of msg by its key
                        self.message = parseJSON["msg"] as? String
                        
                        
                        
                    }
                } catch {
                    print(error)
                }
                
                
                // Inorder to execute only after get response (Main Thread) we hgave to use dispatch_async
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let mytab = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = mytab.objectAtIndex(1) as! UITabBarItem
                    tabItem.badgeValue = self.message
                    
                    
                })
                
                
                
            }//task close
            task.resume()
            
            

            
            
            // request to get all groups
            
            let request1 = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getgroups.php")!)
            request1.HTTPMethod = "POST"
            let postString1 = "uemail=\(uname)"
            print("*********")
            print(uname)
            request1.HTTPBody = postString1.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1)
            {
                data1,response1,error1 in
                if error1 != nil{
                    print("error = \(error1)")
                    return
                }
                
                let strData1 = NSString(data: data1!, encoding: NSUTF8StringEncoding)
                print("All Groups: \(strData1)")
                
                
                do {
                    
                    
                    let myJSON1 =  try NSJSONSerialization.JSONObjectWithData(data1!, options: .MutableContainers) as? NSDictionary
                    
                    print(myJSON1?.count)
                    
                    var i = 1
                    while i <= myJSON1?.count {
                        self.array.append((myJSON1?.valueForKey("\(i)"))! as! String)
                        i += 1
                    }
                    
                    // This will execute after loaded the data so must use dispatch
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableview.dataSource = self
                        self.tableview.delegate = self
                        self.tableview.reloadData()
                    });
                    
                    
                    
                } catch {
                    print(error)
                }
            } // close of task 1
            task1.resume()
            
            
            
            

        }
        
            
            func numberOfSectionsInTableView(tableView: UITableView) -> Int {
                // #warning Incomplete implementation, return the number of sections
                return 1
            }
            func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                return "group names"
            }
            
            func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                // #warning Incomplete implementation, return the number of rows
                return array.count
            }
            
            
            func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
                gname = array[indexPath.row].componentsSeparatedByString(",")
                cell.textLabel?.text = gname[0]
                cell.detailTextLabel?.text = gname[1]
                return cell
            }
        
        
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            let selectedrow = self.array[indexPath.row].componentsSeparatedByString(",")
            selectedgroup = selectedrow[0]
           
            self.performSegueWithIdentifier("groups2Members", sender: self)
            
            
            
        }
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let yourNextViewController = (segue.destinationViewController as? GroupMembersSearchViewController)
           
            yourNextViewController?.groupname = selectedgroup
        }
        
        
        
        
        
        func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            
            let selectedrow = self.array[indexPath.row].componentsSeparatedByString(",")
            let selectedgroup = selectedrow[0]
            let selectedgrpstatus = selectedrow[1]
            
            if(selectedgrpstatus == "admin")
            {
            
             let delete = UITableViewRowAction(style: .Normal, title:"Delete"){(action:UITableViewRowAction, indexPath:NSIndexPath!)-> Void in
                
                // alert to get password
                
                var alertController:UIAlertController?
                alertController = UIAlertController(title: "Deleting Group",
                                                    message: "Enter Group Password",
                                                    preferredStyle: .Alert)
                
                alertController!.addTextFieldWithConfigurationHandler(
                    {(textField: UITextField!) in
                        textField.placeholder = "Enter Password"
                        textField.secureTextEntry = true
                })
                
                let action = UIAlertAction(title: "Delete",
                                           style: UIAlertActionStyle.Default,
                                           handler: {[weak self]
                                            (paramAction:UIAlertAction!) in
                                            if let textFields = alertController?.textFields{
                                                let theTextFields = textFields as [UITextField]
                                                let password = theTextFields[0].text
                                                
                                                
                                                
                                                //    request to check the group password
                                                let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/checkgrppwd.php")!)
                                                request.HTTPMethod = "POST"
                                                let postString = "gname=\(selectedgroup)&gpwd=\(password!)"
                                                
                                                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                                
                                                let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                                                {
                                                    data,response,error in
                                                    if error != nil{
                                                        print("error = \(error)")
                                                        return
                                                    }
                                                    let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                    print("Response of the password status: \(strData)")
                                                    
                                                    
                                                    do {
                                                        let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                                                        print(myJSON)
                                                        if let parseJSON = myJSON {
                                                            
                                                            // Now we can access value of msg by its key
                                                            self!.pwdstatus = parseJSON["msg"] as? String
                                                            
                                                            print("password messages,\(self!.pwdstatus)")
                                                            
                                                        }
                                                    } catch {
                                                        print(error)
                                                    }
                                                    
                                                    // if status success then proceed to delete the group
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                        if(self!.pwdstatus == "1")
                                                        {
                                                            //request to leave the group
                                                            
                                                            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/deletegroup.php")!)
                                                            request.HTTPMethod = "POST"
                                                            let postString = "uname=\(self!.uname)&gname=\(selectedgroup)"
                                                            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                                            
                                                            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                                                            {
                                                                data,response,error in
                                                                if error != nil{
                                                                    print("error = \(error)")
                                                                    return
                                                                }
                                                                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                                print("Response of the leave group status: \(strData)")
                                                                
                                                                
                                                                do {
                                                                    let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                                                                    print(myJSON)
                                                                    if let parseJSON = myJSON {
                                                                        
                                                                        // Now we can access value of msg by its key
                                                                        self!.status = parseJSON["msg"] as? String
                                                                        
                                                                        print("Leave group Message,\(self!.status)")
                                                                        
                                                                    }
                                                                } catch {
                                                                    print(error)
                                                                }
                                                                
                                                                // Get and show the status
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                                    if(self!.status == "1")
                                                                    {
                                                                        self!.array.removeAtIndex(indexPath.row)
                                                                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                                                                    }
                                                                    else
                                                                    {
                                                                        //record not deleted
                                                                        
                                                                    }
                                                                    
                                                                })
                                                                
                                                                
                                                                
                                                            }//task close
                                                            task.resume()
                                                            
                                                            
                                                        } // if close
                                                        else
                                                        {
                                                            // password doesnt match
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                    })
                                                    
                                                    
                                                    
                                                }//task close
                                                task.resume()
                                                
                                                
                                            }
                    })
                
                alertController?.addAction(action)
                alertController!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    // function to do after cancel
                    
                    }))
                
                self.presentViewController(alertController!,
                                           animated: true,
                                           completion: nil)
                
                
                
                
                           }
            delete.backgroundColor = UIColor.redColor()
                
                return [delete]
            
            }
            else{
                let leave = UITableViewRowAction(style: .Normal, title:"Leave"){(action:UITableViewRowAction, indexPath:NSIndexPath!)-> Void in
                    
                    // alert to get password
                    
                    
                    
                    var alertController:UIAlertController?
                    alertController = UIAlertController(title: "Leaving Group",
                                                        message: "Enter Group Password",
                                                        preferredStyle: .Alert)
                    
                    alertController!.addTextFieldWithConfigurationHandler(
                        {(textField: UITextField!) in
                            textField.placeholder = "Enter Password"
                            textField.secureTextEntry = true
                    })
                    
                    let action = UIAlertAction(title: "Leave",
                                               style: UIAlertActionStyle.Default,
                                               handler: {[weak self]
                                                (paramAction:UIAlertAction!) in
                                                if let textFields = alertController?.textFields{
                                                    let theTextFields = textFields as [UITextField]
                                                    let password = theTextFields[0].text
                                                
                                                    
                                                    
                                                //    request to check the group password
                                                    let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/checkgrppwd.php")!)
                                                    request.HTTPMethod = "POST"
                                                    let postString = "gname=\(selectedgroup)&gpwd=\(password!)"
                                                    
                                                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                                    
                                                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                                                    {
                                                        data,response,error in
                                                        if error != nil{
                                                            print("error = \(error)")
                                                            return
                                                        }
                                                        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                        print("Response of the password status: \(strData)")
                                                        
                                                        
                                                        do {
                                                            let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                                                            print(myJSON)
                                                            if let parseJSON = myJSON {
                                                                
                                                                // Now we can access value of msg by its key
                                                                self!.pwdstatus = parseJSON["msg"] as? String
                                                                
                                                                print("password messages,\(self!.pwdstatus)")
                                                                
                                                            }
                                                        } catch {
                                                            print(error)
                                                        }
                                                        
                                                        // if status success then proceed to leave the group
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                            if(self!.pwdstatus == "1")
                                                            {
                                                                //request to leave the group
                                                                
                                                                let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/leavegroup.php")!)
                                                                request.HTTPMethod = "POST"
                                                                let postString = "uname=\(self!.uname)&gname=\(selectedgroup)"
                                                                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                                                
                                                                let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                                                                {
                                                                    data,response,error in
                                                                    if error != nil{
                                                                        print("error = \(error)")
                                                                        return
                                                                    }
                                                                    let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                                    print("Response of the leave group status: \(strData)")
                                                                    
                                                                    
                                                                    do {
                                                                        let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                                                                        print(myJSON)
                                                                        if let parseJSON = myJSON {
                                                                            
                                                                            // Now we can access value of msg by its key
                                                                            self!.status = parseJSON["msg"] as? String
                                                                            
                                                                            print("Leave group Message,\(self!.status)")
                                                                            
                                                                        }
                                                                    } catch {
                                                                        print(error)
                                                                    }
                                                                    
                                                                    // Get and show the status
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                                        if(self!.status == "1")
                                                                        {
                                                                            self!.array.removeAtIndex(indexPath.row)
                                                                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                                                                        }
                                                                        else
                                                                        {
                                                                            
                                                                        }
                                                                        
                                                                    })
                                                                    
                                                                    
                                                                    
                                                                }//task close
                                                                task.resume()
                                                               
                                                                
                                                            } // if close
                                                            else
                                                            {
                                                                // password doesnt match
                                                                
                                                                
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                        })
                                                        
                                                        
                                                        
                                                    }//task close
                                                    task.resume()
                                                 
                                                
                                                  }
                        })
                    alertController!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                        // function to do after cancel
                        
                    }))
                    alertController?.addAction(action)
                    self.presentViewController(alertController!,
                                               animated: true,
                                               completion: nil)
                
                
                
              }
                leave.backgroundColor = UIColor.redColor()
                
                return [leave]
            }
            
            
        }
        
        
        
        
        
        
        
        
        
        var locations = [MKPointAnnotation]()
        
        lazy var locationManager: CLLocationManager! = {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.delegate = self
            manager.requestAlwaysAuthorization()
            return manager
        }()
        
        func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
            
            // After we get latitude and lngitude we have to save it in database using request & response
            
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/insertlocation.php")!)
            request.HTTPMethod = "POST"
            let postString = "uname=\(uname)&ulatitude=\(newLocation.coordinate.latitude)&ulongitude=\(newLocation.coordinate.longitude)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data,response,error in
                if error != nil{
                    print("error = \(error)")
                    return
                }
          }
            task.resume()
        
        }
        
        
        
        @IBAction func logout(sender: AnyObject) {
            
            defaults.removeObjectForKey("username")
            defaults.removeObjectForKey("password")
            defaults.synchronize()
            
        }
    }



