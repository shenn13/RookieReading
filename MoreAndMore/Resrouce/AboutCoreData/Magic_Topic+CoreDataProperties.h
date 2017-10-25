//
//  Magic_Topic+CoreDataProperties.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Magic_Topic.h"

NS_ASSUME_NONNULL_BEGIN

@interface Magic_Topic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *comics_count;
@property (nullable, nonatomic, retain) NSNumber *comments_count;
@property (nullable, nonatomic, retain) NSString *cover_image_url;
@property (nullable, nonatomic, retain) NSString *created_at;
@property (nullable, nonatomic, retain) NSString *discover_image_url;
@property (nullable, nonatomic, retain) NSString *idd;
@property (nullable, nonatomic, retain) NSNumber *is_favourite;
@property (nullable, nonatomic, retain) NSString *label_color;
@property (nullable, nonatomic, retain) NSNumber *label_id;
@property (nullable, nonatomic, retain) NSString *label_text;
@property (nullable, nonatomic, retain) NSString *label_text_color;
@property (nullable, nonatomic, retain) NSNumber *likes_count;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSString *pic;
@property (nullable, nonatomic, retain) NSString *recommended_text;
@property (nullable, nonatomic, retain) NSString *target_id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *topic_description;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *updated_at;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *vertical_image_url;
@property (nullable, nonatomic, retain) Magic_User *user;

@end

NS_ASSUME_NONNULL_END
