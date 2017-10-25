//
//  DrawAccount.h
//  schoolfriends
//
//  Created by Silence on 16/6/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/*
 accountNumber = 18772103608;
 accountType = 1;
 createTime = 1466590083000;
 openid = "";
 realName = "\U738b\U632f\U5174";
 updateTime = 1466590083000;
 userId = 1002;
 */

@interface DrawAccount : NSObject

@property (nonatomic,copy)NSString *accountNumber;

//  账号类型（1：支付宝，2：微信）
@property (nonatomic,assign)int accountType;

@property (nonatomic,assign)NSInteger createTime;

@property (nonatomic,assign)NSInteger updateTime;

@property (nonatomic,copy)NSString *openid;

@property (nonatomic,copy)NSString *realName;
//  账号所属用户ID
@property (nonatomic,copy)NSString *userId;

@end
