//
//  SearchTableViewController.swift
//  WMGA
//
//  Created by  on 7/2/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate{
    

    
    var searchController:UISearchController!
    var resultController = UITableViewController()
    var array = [String]()
    var resultArray = [String]()
    var selectedgroupname:String!
    var selectedMemname:String!
    var status:String! // status of response url
    var defaults = NSUserDefaults.standardUserDefaults()
    var uname:String!
        override func viewDidLoad() {
        super.viewDidLoad()
            self.resultController.tableView.delegate = self
            self.resultController.tableView.dataSource = self
            self.searchController = UISearchController(searchResultsController: self.resultController)
            self.searchController.loadViewIfNeeded()
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.searchController.searchResultsUpdater = self
            uname = defaults.stringForKey("username")!
            
            print("**** In Search View Controller ****")
            print(selectedgroupname)
            
            // Get all members list from database
        
            
            let request1 = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/getmembers.php")!)
            print("***** In Search Members *******")
            request1.HTTPMethod = "POST"
            print(uname)
            let postString = "uemail=\(uname)"
            request1.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            

            
            let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1)
            {
                data1,response1,error1 in
                if error1 != nil{
                    print("error = \(error1)")
                    return
                }
                
                let strData1 = NSString(data: data1!, encoding: NSUTF8StringEncoding)
                print("All Members: \(strData1)")
                
                
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
                    
                    
                    
                } catch {
                    print(error)
                }
            } // close of task 1
            task1.resume()
            

            
            
            
            
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.resultArray = self.array.filter {(name:String) -> Bool in
            if name.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString){
                return true
            }
            else{
                return false
            }
        
        }
    
    
   self.resultController.tableView.reloadData()
    }
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView
        {
        return array.count
        }
        else{
            return self.resultArray.count
        }
    }
  
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCellWithIdentifier("searchmembers", forIndexPath: indexPath)
        if tableView == self.tableView
        {
        cell.textLabel?.text = self.array[indexPath.row]
        }
        else{
            cell.textLabel?.text = self.resultArray[indexPath.row]
            
        }

        // Configure the cell...

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
//        print(currentCell.textLabel!.text)
        
        selectedMemname = self.array[indexPath!.row]
        print(selectedMemname)
        if(selectedMemname == nil)
        {
            
            
        }
        else
        {
            // Request to add selected member to selected group in database
            
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/addmem2grp.php")!)
            request.HTTPMethod = "POST"
            
            
            let postString = "uemail=\(selectedMemname)&ugroup=\(selectedgroup)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            // make task to save data into database
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data,response,error in
                if error != nil{
                    print("error = \(error)")
                    return
                }
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Group Body: \(strData)")
                
                
                do {
                    let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print(myJSON)
                    if let parseJSON = myJSON {
                        
                        // Now we can access value of msg by its key
                        self.status = parseJSON["msg"] as? String
                        
                        print("Group Message,\(self.status)")
                        
                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
            if(self.status != "0")
            {
            
       self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Alert"
                
                alert.addButtonWithTitle("OK")
                alert.message = "Sorry user already added to the group.. please try with another user"
                alert.show()
                
            }
        }
        
       
        }
        
    }

    





