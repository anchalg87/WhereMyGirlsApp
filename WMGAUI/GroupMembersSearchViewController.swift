//
//  GroupMembersSearchViewController.swift
//  WMGA
//
//  Created by  on 7/2/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit

class GroupMembersSearchViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet var tableview: UITableView!
    @IBOutlet var add: UIBarButtonItem!
    //variables
    var array1 = [String]()
    var gid = 100
    let def = NSUserDefaults.standardUserDefaults()
    var groupname:String!
    var selectedUser:String!
    var uname:String!
    var message:String!
    
    // Outlets and actions
    @IBOutlet var table: UITableView!
    
    @IBAction func addMember(sender: AnyObject) {
        self.performSegueWithIdentifier("members2Search", sender: self)
        
        
    }
   
        override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
         uname = def.stringForKey("username")!
            
        // request to know whether he is admin to the group or not
            
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getgroupadmin.php")!)
            request.HTTPMethod = "POST"
            let postString = "uname=\(uname)&gname=\(groupname)"
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
                    
                  if(self.message=="0" || self.message == "error")
                  {
                    self.add.enabled = false
                    }
                    else if(self.message == "1")
                  {
                    self.add.enabled = true
                    }
                    else
                  {
                    self.add.enabled = false
                    
                    }
                    
                })
                
                
                
            }//task close
            task.resume()
            
          
    }

    
    
    
   
    override func viewWillAppear(animated: Bool) {
        
        // Get all members list of that group from database
        array1.removeAll()
        
        let request1 = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getgroupmembers.php")!)
        print("***** In Group Members Display*******")
        request1.HTTPMethod = "POST"
        print(groupname)
        let postString = "ugname=\(groupname)"
        request1.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1)
        {
            data1,response1,error1 in
            if error1 != nil{
                print("error = \(error1)")
                return
            }
            
            let strData1 = NSString(data: data1!, encoding: NSUTF8StringEncoding)
            print("All Members of that group: \(strData1)")
            
            
            do {
                
                
                let myJSON1 =  try NSJSONSerialization.JSONObjectWithData(data1!, options: .MutableContainers) as? NSDictionary
                
               
                
                var i = 1
                while i <= myJSON1?.count {
                    self.array1.append((myJSON1?.valueForKey("\(i)"))! as! String)
                    i += 1
                }
                self.array1.append("All Members")
                // This will execute after loaded the data so must use dispatch
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.table.delegate = self
                    self.table.dataSource = self
                    
                    self.table.reloadData()

                    
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("In no of rows in section function Array count:::")
        print(array1.count)
        return array1.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberscell",forIndexPath: indexPath)
        cell.textLabel?.text = self.array1[indexPath.row]

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedUser = self.array1[indexPath.row]
        print("*********")
        print(selectedUser)
        
        self.performSegueWithIdentifier("memberLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
            if(segue.identifier == "memberLocation")
            {
                
                let yourNextViewController = (segue.destinationViewController as? MemberLocationViewController)
                
                yourNextViewController?.uname = selectedUser
                yourNextViewController?.gname = self.groupname
                
        }
        else
            {
            let yourNextViewController = (segue.destinationViewController as? SearchTableViewController)
            
            yourNextViewController?.selectedgroupname = self.groupname
        }
     
    }
    
}
