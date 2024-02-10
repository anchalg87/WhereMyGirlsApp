//
//  GroupNames.swift
//  WMGA
//
//  Created by  on 7/8/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import Foundation
import CoreData

@objc(GroupNames)
class GroupNames: NSManagedObject {

    
 var localArr = [String]()
    func addGroupNames(gid: NSInteger,uname:NSString,gname:NSString,managedContext: NSManagedObjectContext)->Int
    {
        
        let entity =  NSEntityDescription.entityForName("GroupNames",
                                                        inManagedObjectContext:managedContext)
        
        let gn = NSManagedObject(entity: entity!,
                                 insertIntoManagedObjectContext: managedContext)
        
        // Fetch records if username already exists or not
        let fetchRequest = NSFetchRequest()
        let fetchpredicate = NSPredicate(format: "uname = %@ AND gname = %@",uname,gname)
        fetchRequest.entity = entity
        fetchRequest.predicate=fetchpredicate
        var fetcherror: NSError? = nil
        let fetchcount = managedContext .countForFetchRequest(fetchRequest, error: &fetcherror)
        
        
        if(fetchcount==0)
        {
            gn.setValue(gid, forKey: "gid")
            gn.setValue(uname, forKey: "uname")
            gn.setValue(gname, forKey: "gname")
            do {
                try managedContext.save()
                return 2    // Success
            }catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        else
        {
            return 1   // gname+uname already exists
        }
        
        
        
        
        return 0   // Error
    }
      
}





