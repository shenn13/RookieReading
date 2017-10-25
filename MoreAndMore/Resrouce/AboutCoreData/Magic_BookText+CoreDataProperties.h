//
//  Magic_BookText+CoreDataProperties.h
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Magic_BookText.h"

NS_ASSUME_NONNULL_BEGIN

@interface Magic_BookText (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isCollect;
@property (nullable, nonatomic, retain) NSString *idd;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSNumber *banned;
@property (nullable, nonatomic, retain) NSString *cat;
@property (nullable, nonatomic, retain) NSString *cover;
@property (nullable, nonatomic, retain) NSNumber *latelyFollower;
@property (nullable, nonatomic, retain) NSNumber *latelyFollowerBase;
@property (nullable, nonatomic, retain) NSNumber *minRetentionRatio;
@property (nullable, nonatomic, retain) NSString *retentionRatio;
@property (nullable, nonatomic, retain) NSString *shortIntro;
@property (nullable, nonatomic, retain) NSString *site;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
