//
//  GroupCreateViewController.swift
//  WMGA
//
//  Created by Capstone on 7/20/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit

class GroupCreateViewController: UIViewController {

    @IBOutlet weak var gnametxtfld: UITextField!
    @IBOutlet weak var gpswdtxtfld: UITextField!
    
  
    @IBOutlet var msglbl: UILabel!
    
     let defaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBAction func groupCreate(sender: AnyObject) {
        var status = String?()
        let uname = self.defaults.stringForKey("username")!
        let groupname = gnametxtfld.text!
        let gpswd = gpswdtxtfld.text!
        
        // Request to store group name in database
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/addgroup.php")!)
        request.HTTPMethod = "POST"
        
        
        let postString = "uemail=\(uname)&ugroup=\(groupname)&ugrpswd=\(gpswd)"
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
                    status = parseJSON["msg"] as? String
                    
                    print("Group Message,\(status)")
                    
                }
            } catch {
                print(error)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                
                if(status == "0")
                {
                    self.msglbl.text = "Error in adding groupname please try again.."
                   
                    self.performSegueWithIdentifier("back2Welcome", sender: self)
                    
                    
                }
                else if(status == "2")
                {
                    self.msglbl.text = "Groupname already exsists"
              
                }
                else if(status == "1")
                {
                    self.msglbl.text = "Successfully added group"
                    
                    

                }
                
            })

            
            // task dispatch close
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
