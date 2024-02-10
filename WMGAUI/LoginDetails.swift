//
//  LoginDetails.swift
//  WMGA
//
//  Created by Capstone on 6/25/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import Foundation
import CoreData

@objc(LoginDetails)
class LoginDetails: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    

    
    func addUserDetails(Uname: NSString, Uemail:NSString, Upwd:NSString, Uphone:NSInteger, managedContext: NSManagedObjectContext) -> Int
    {
        
        
        let entity =  NSEntityDescription.entityForName("LoginDetails",
                                                        inManagedObjectContext:managedContext)
        
        let ld = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        
        // Fetch records if username already exists or not
        let fetchRequest = NSFetchRequest()
        let fetchpredicate = NSPredicate(format: "uname= %@",Uname)
        fetchRequest.entity = entity
        fetchRequest.predicate=fetchpredicate
        var fetcherror: NSError? = nil
        let fetchcount = managedContext .countForFetchRequest(fetchRequest, error: &fetcherror)

        
        if(fetchcount==0)
        {
        ld.setValue(Uname, forKey: "uname")
        ld.setValue(Uemail, forKey: "uemail")
        ld.setValue(Upwd, forKey: "upwd")
        ld.setValue(Uphone, forKey: "uphone")
            
        do {
            try managedContext.save()
            return 2    // Success
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        }
        else
        {
            return 1   // Username exists
        }
        
        
        
        
     return 0   // Error
    }

    
    func getUserDetails(Uname: NSString, Upwd: NSString, managedcontext: NSManagedObjectContext) -> NSString
    {
        let entity =  NSEntityDescription.entityForName("LoginDetails",
                                                        inManagedObjectContext:managedcontext)
        let fetchRequest = NSFetchRequest()
        let fetchpredicate = NSPredicate(format: "uname= %@",Uname)
        fetchRequest.entity = entity
        fetchRequest.predicate=fetchpredicate
        var fetcherror: NSError? = nil
        let fetchcount = managedcontext .countForFetchRequest(fetchRequest, error: &fetcherror)
        print(fetchcount)
        if(fetchcount>0)
        {
            let rs = (try? managedcontext.executeFetchRequest(fetchRequest)) as? [NSManagedObject] ?? []
            
            
            for res in rs
            {
                if(res.valueForKey("upwd") as! String == Upwd)
                {
                    return "Success"
                }
                else{
                    return "Failure"
                }
            }

            
        }
        
        else{
            return "Failure"
        }
        
        return "Error"
        
    }


}