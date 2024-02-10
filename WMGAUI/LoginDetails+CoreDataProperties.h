//
//  LoginDetails+CoreDataProperties.h
//  WMGA
//
//  Created by Capstone on 6/25/16.
//  Copyright © 2016 uhcl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LoginDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSString *uname;
@property (nullable, nonatomic, retain) NSNumber *uphone;
@property (nullable, nonatomic, retain) NSString *uemail;
@property (nullable, nonatomic, retain) NSString *upwd;

@end

NS_ASSUME_NONNULL_END
