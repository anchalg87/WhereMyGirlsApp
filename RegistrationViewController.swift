//
//  RegistrationViewController.swift
//  WMGA
//
//  Created by  on 6/23/16.
//  Copyright © 2016 uhcl. All rights reserved.
//


import UIKit



class RegistrationViewController: UIViewController {
    
    
    var urlString:String!
    var message:String?  // response to our msg

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var phonenumber: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmpwd: UITextField!
    
    @IBOutlet weak var aptno: UITextField!
    
    @IBOutlet weak var zipcode: UITextField!
    
    @IBOutlet weak var address: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func Submit(sender: AnyObject) {
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://localhost/WMGA/insert.php")!)
        request.HTTPMethod = "POST"
        let postString = "uname=\(username.text!)&upwd=\(password.text!)&uemail=\(email.text!)&uphone= \(phonenumber.text!)&uaptno= \(aptno.text!)&uaddress= \(address.text!)&uzipcode= \(zipcode.text!)"
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
                
            let alert = UIAlertView()
            alert.title = "Alert"
            
            alert.addButtonWithTitle("OK")
            let msg: String?
            
            if(self.message == "0")
            {
                msg = "Error in registering please try again.."
                alert.message = msg
                alert.show()
                self.performSegueWithIdentifier("back2Welcome", sender: self)
                
                
            }
            else if(self.message == "2")
            {
                msg = "EmailID already exists please try again with some other Email"
                alert.message = msg
                alert.show()
                
                
            }
            else if(self.message == "1")
            {
                msg = "Successfull in registering"
                alert.message = msg
                alert.show()
                self.performSegueWithIdentifier("success2Tabbar", sender: self)
                
                // Maintain Session
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.email.text, forKey: "username")
                defaults.setObject(self.password.text, forKey: "password")
                defaults.synchronize()
                
                
                
                
            }
            
            })
            
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    @IBAction func Reset(sender: UIButton) {
        
        username.text = ""
        phonenumber.text = ""
        email.text = ""
        password.text = ""
        confirmpwd.text = ""
        aptno.text = ""
        zipcode.text = ""
        address.text = ""
        
    }
    
    
    
    
}