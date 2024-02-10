//
//  GroupMembers+CoreDataProperties.swift
//  WMGA
//
//  Created by  on 7/8/16.
//  Copyright © 2016 uhcl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension GroupMembers {

    @NSManaged var gid: NSNumber?
    @NSManaged var memName: String?

}
