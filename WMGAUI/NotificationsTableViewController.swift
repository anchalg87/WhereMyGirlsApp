//
//  NotificationsTableViewController.swift
//  WMGA
//
//  Created by Capstone on 7/31/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {
 var defaults = NSUserDefaults.standardUserDefaults()
 var uname:String!
var status:String!
 var array = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        // request to get all notifications
        array.removeAll()
        uname = defaults.stringForKey("username")!
        let request1 = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getNotifications.php")!)
        request1.HTTPMethod = "POST"
        let postString1 = "uname=\(uname)"
        
        request1.HTTPBody = postString1.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1)
        {
            data1,response1,error1 in
            if error1 != nil{
                print("error = \(error1)")
                return
            }
            
            let strData1 = NSString(data: data1!, encoding: NSUTF8StringEncoding)
            print("All Notifications: \(strData1)")
            
            
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

                  self.tableView.reloadData()
                });
                
                
                
            } catch { print(error)}
        } // close of task 1
        task1.resume()
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.msg.text = "you are added to "+array[indexPath.row]+" is the admin for this group."
        

        return cell
    }
 

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let selectedrow = self.array[indexPath.row].componentsSeparatedByString(",")
        let selectedgroup = selectedrow[0]
        
        let accept = UITableViewRowAction(style: .Normal, title:"Accept"){(action:UITableViewRowAction, indexPath:NSIndexPath!)-> Void in
            
            print(selectedgroup)
            
            //request to update status
            
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/acceptnotifications.php")!)
            request.HTTPMethod = "POST"
            let postString = "uname=\(self.uname)&gname=\(selectedgroup)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data,response,error in
                if error != nil{
                    print("error = \(error)")
                    return
                }
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Response of the update status: \(strData)")
                
                
                do {
                    let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print(myJSON)
                    if let parseJSON = myJSON {
                        
                        // Now we can access value of msg by its key
                        self.status = parseJSON["msg"] as? String
                        
                        print("Notification Declined Message,\(self.status)")
                        
                    }
                } catch {
                    print(error)
                }
                
                // Get and show the status
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(self.status == "1")
                    {
                        self.array.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                    else
                    {
                        
                    }
                    
                })
                
                
            
            }//task close
            task.resume()
            } //accept close
        
        accept.backgroundColor = UIColor.greenColor()
        
        let decline = UITableViewRowAction(style: .Normal, title:"Decline"){(action:UITableViewRowAction, indexPath:NSIndexPath!)-> Void in
           
            //request to update status to 2
            
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/declinenotifications.php")!)
            request.HTTPMethod = "POST"
            let postString = "uname=\(self.uname)&gname=\(selectedgroup)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data,response,error in
                if error != nil{
                    print("error = \(error)")
                    return
                }
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Response of the update status: \(strData)")
                
                
                do {
                    let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print(myJSON)
                    if let parseJSON = myJSON {
                        
                        // Now we can access value of msg by its key
                        self.status = parseJSON["msg"] as? String
                        
                        print("Notification accepted Message,\(self.status)")
                        
                    }
                } catch {
                    print(error)
                }
                
                // Get and show the status
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(self.status == "1")
                    {
                        self.array.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                    else
                    {
                        
                    }
                    
                })
                
                
                
            }//task close
            task.resume()

            
            
            
        }
        
        decline.backgroundColor = UIColor.redColor()
        
        return [decline, accept]
    }
    
    
}
