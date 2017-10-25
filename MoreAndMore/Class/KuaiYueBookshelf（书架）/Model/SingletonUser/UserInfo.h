//
//  UserInfo.h
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"

@interface UserInfo : BaseArchiveModel<NSCopying>

/************************新增字段**************************/
//  二维码
@property (nonatomic,copy)NSString *qrCode;
//  当前认证状态（1：已认证，2：未认证）
@property (nonatomic,assign)NSInteger isAuth;

@property (nonatomic,weak)UIImage *userIconImage;
@property (nonatomic,weak)UIImage *backIconImage;

/**************************************************/
//  用户类型（1：个人，2：商家，3：组织）
@property (nonatomic,assign)int userType;
//  用户ID
@property (nonatomic,copy)NSString *userId;
//  用户昵称
@property (nonatomic,copy)NSString *userName;
//  用户手机号(必须唯一)
@property (nonatomic,copy)NSString *phone;
//  登录密码
@property (nonatomic,copy)NSString *loginPwd;
//  所在地区（省份+城市）
@property (nonatomic,copy)NSString *area;
//  用户头像（存储url）
@property (nonatomic,copy)NSString *avatar;
//  人个主页背景图片
@property (nonatomic,copy)NSString *bgImage;
//  出生年月日
@property (nonatomic,assign)NSInteger borndate;
//  提现密码
@property (nonatomic,copy)NSString *drawPwd;
//  邮箱地址
@property (nonatomic,copy)NSString *email;

//  纬度
@property (nonatomic,assign)double latitude;
//  经度
@property (nonatomic,assign)double longitude;
//  学校名称
@property (nonatomic,copy)NSString *schoolName;
//  用户性别（男0、女1、保密2）
@property (nonatomic,assign)NSInteger sex;
//  个性签名
@property (nonatomic,copy)NSString *signature;
//  userName第一个字符首字母（A~Z,其它为~）
@property (nonatomic,copy)NSString *firstCharName;

/**************************************************/
//  更新时间
@property (nonatomic,assign)NSInteger updateTime;
//  注册时间
@property (nonatomic,assign)NSInteger createTime;
//  是否被锁定（0：未锁定，1：已锁定）
@property (nonatomic,assign)int isLocked;
//  上次登录IP
@property (nonatomic,copy)NSString *lastLoginIp;
//  上次登录时间
@property (nonatomic,assign)NSInteger lastLoginTime;
//  注册IP
@property (nonatomic,copy)NSString *registerIp;
//  注册来源（1：安卓手机，2：苹果手机）
@property (nonatomic,assign)int registerFrom;
//  用户当前使用手机类型（1：安卓用户，2：苹果用户）
@property (nonatomic,assign)int appType;
//  搜索列(userName+area+schoolName)
@property (nonatomic,copy)NSString *searchValue;


//  绑定支付宝账号
@property (nonatomic,copy)NSString *alipayAccount;

/**************************************************/
//  环信UId
@property (nonatomic,copy)NSString *hxUId;
//  环信通讯密码
@property (nonatomic,copy)NSString *hxPwd;

/**************************************************/
//  微信号
@property (nonatomic,copy)NSString *weixinAccount;
//  微信用户唯一标识符openId
@property (nonatomic,copy)NSString *weixinOId;
//  微信UnionId
@property (nonatomic,copy)NSString *weixinUId;
//  微信昵称
@property (nonatomic,copy)NSString *weixinUname;

/**************************************************/
//  绑定QQ号
@property (nonatomic,copy)NSString *bindQQ;
//  绑定QQ的openId
@property (nonatomic,copy)NSString *qqOId;

/**************************************************/
//  新浪微博UId
@property (nonatomic,copy)NSString *weiboUId;
//  绑定新浪微博
@property (nonatomic,copy)NSString *weiboXL;

@end
