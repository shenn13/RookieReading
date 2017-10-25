//
//  UserInfo.m
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(id)copyWithZone:(NSZone *)zone
{
    UserInfo *userInfo = [UserInfo allocWithZone:zone];
    
    userInfo.qrCode = self.qrCode;
    userInfo.isAuth = self.isAuth;
    
    userInfo.userId = self.userId;
    userInfo.userType = self.userType;
    userInfo.userName = self.userName;
    userInfo.firstCharName = self.firstCharName;
    userInfo.phone = self.phone;
    userInfo.loginPwd = self.loginPwd;
    userInfo.avatar = self.avatar;
    userInfo.sex = self.sex;
    userInfo.borndate = self.borndate;
    userInfo.email = self.email;
    userInfo.signature = self.signature;
    userInfo.area = self.area;
    userInfo.schoolName = self.schoolName;
    userInfo.bgImage = self.bgImage;
    userInfo.hxUId = self.hxUId;
    userInfo.hxPwd = self.hxPwd;
    userInfo.drawPwd = self.drawPwd;
    userInfo.appType = self.appType;
    userInfo.isLocked = self.isLocked;
    userInfo.registerIp = self.registerIp;
    userInfo.registerFrom = self.registerFrom;
    userInfo.createTime = self.createTime;
    userInfo.updateTime = self.updateTime;
    userInfo.searchValue = self.searchValue;
    userInfo.lastLoginIp = self.lastLoginIp;
    userInfo.lastLoginTime = self.lastLoginTime;
    userInfo.longitude = self.longitude;
    userInfo.latitude = self.latitude;
    userInfo.weixinAccount = self.weixinAccount;
    userInfo.weixinUname = self.weixinUname;
    userInfo.weixinOId = self.weixinOId;
    userInfo.weixinUId = self.weixinUId;
    userInfo.weiboXL = self.weiboXL;
    userInfo.weiboUId = self.weiboUId;
    userInfo.bindQQ = self.bindQQ;
    userInfo.qqOId = self.qqOId;
    userInfo.alipayAccount = self.alipayAccount;
    
    return userInfo;
}

@end
