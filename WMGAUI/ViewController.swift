//
//  ViewController.swift
//  WMGA
//
//  Created by  on 6/23/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    var status:String?   // response of url
    
    @IBOutlet weak var emailId: UITextField!
    
    @IBOutlet weak var pwd: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if defaults .objectForKey("username") != nil && !defaults.objectForKey("username")!.isEqualToString(" ")
        {
            self.performSegueWithIdentifier("login2Tabbar", sender: self)
           
        }
    }
        
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func Login(sender: AnyObject) {
        
        let username = emailId.text
        let password = pwd.text
        
        if(username!.isEmpty || password!.isEmpty)
        {
            let loginAlert = UIAlertController(title:"Error",
                                               message:"All fields are required.",preferredStyle:UIAlertControllerStyle.Alert)
            
            loginAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
        else
        {
            
            let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/login.php")!)
            request.HTTPMethod = "POST"
            let postString = "uemail=\(emailId.text!)&upwd=\(pwd.text!)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data,response,error in
                if error != nil{
                    print("error = \(error)")
                    return
                }
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                
                
                do {
                    let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print(myJSON)
                    if let parseJSON = myJSON {
                        
                        // Now we can access value of msg by its key
                        self.status = parseJSON["msg"] as? String
                        
                        print("Login Message,\(self.status)")
                        
                    }
                } catch {
                    print(error)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(self.status == "2")
                    {
                        let loginAlert = UIAlertController(title:"Error",
                            message:"Sorry Uname or password doesn't exists..",preferredStyle:UIAlertControllerStyle.Alert)
                        
                        loginAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(loginAlert, animated: true, completion: nil)
                    }
                        
                    else if(self.status == "0")
                    {
                        
                        let loginAlert = UIAlertController(title:"Error",
                            message:"Server is busy please try again..",preferredStyle:UIAlertControllerStyle.Alert)
                        
                        loginAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(loginAlert, animated: true, completion: nil)
                    }
                        
                    else if(self.status == "3")
                    {
                        
                        let loginAlert = UIAlertController(title:"Error",
                            message:"Username and Password doesn't matches to our record.. please try again",preferredStyle:UIAlertControllerStyle.Alert)
                        
                        loginAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(loginAlert, animated: true, completion: nil)
                    }
                        
                        
                    else{
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(username, forKey: "username")
                        defaults.setObject(password, forKey: "password")
                        defaults.synchronize()
                        
                        self.performSegueWithIdentifier("login2Tabbar", sender: self)
                        
                    }
                    
                })
            }
            task.resume()
            
            
        }
            
            
        }

    
    
    @IBAction func Register(sender: AnyObject) {
        
    }
    
   
    
}
