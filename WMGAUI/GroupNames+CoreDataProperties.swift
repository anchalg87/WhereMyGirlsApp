//
//  GroupNames+CoreDataProperties.swift
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

extension GroupNames {

    @NSManaged var uname: String?
    @NSManaged var gname: String?
    @NSManaged var gid: NSNumber?

}
