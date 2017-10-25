//
//  Magic_User+CoreDataProperties.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Magic_User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Magic_User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *grade;
@property (nullable, nonatomic, retain) NSString *avatar_url;
@property (nullable, nonatomic, retain) NSString *reg_type;
@property (nullable, nonatomic, retain) NSString *idd;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSNumber *pub_feed;

@end

NS_ASSUME_NONNULL_END
