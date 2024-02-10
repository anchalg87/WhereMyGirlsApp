//
//  GroupMembers.swift
//  WMGA
//
//  Created by  on 7/8/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

import Foundation
import CoreData


class GroupMembers: NSManagedObject {

    func addGroupMembersToGroup(gid: NSInteger,memName:NSString,managedContext: NSManagedObjectContext)->Int
    {
        let entity =  NSEntityDescription.entityForName("GroupMembers",
                                                        inManagedObjectContext:managedContext)
        
        let gm = NSManagedObject(entity: entity!,
                                 insertIntoManagedObjectContext: managedContext)
        
        // Fetch records if username already exists or not
        let fetchRequest = NSFetchRequest()
        let fetchpredicate = NSPredicate(format: "memName = %@ ",memName)
        fetchRequest.entity = entity
        fetchRequest.predicate=fetchpredicate
        var fetcherror: NSError? = nil
        let fetchcount = managedContext .countForFetchRequest(fetchRequest, error: &fetcherror)
        
        
        if(fetchcount==0)
        {
            gm.setValue(gid, forKey: "gid")
            gm.setValue(memName, forKey: "memName")
          
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


