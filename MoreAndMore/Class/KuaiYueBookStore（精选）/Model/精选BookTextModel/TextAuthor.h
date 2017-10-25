//
//  TextAuthor.h
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextAuthor : NSObject

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,copy)NSString *avatar;

@property (nonatomic,copy)NSString *gender;

// 等级
@property (nonatomic,assign)NSInteger lv;

@property (nonatomic,copy)NSString *nickname;

@property (nonatomic,copy)NSString *type;

@end
