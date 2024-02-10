//
//  LoginDetails+CoreDataProperties.swift
//  WMGA
//
//  Created by Capstone on 6/25/16.
//  Copyright © 2016 uhcl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LoginDetails {

    @NSManaged var uid: NSNumber?
    @NSManaged var uname: String?
    @NSManaged var uphone: NSNumber?
    @NSManaged var uemail: String?
    @NSManaged var upwd: String?

}
