//
//  SingletonUser.h
//  schoolfriends
//
//  Created by Silence on 16/3/30.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"

#import "Singleton.h"  // 宏定义快速实现单例

#import "UserInfo.h"
#import "BindedBankCard.h"
#import "UserAccount.h"
#import "UserCertify.h"
#import "UserStatistics.h"

#define USER_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"SingerUser.plist"]

@interface SingletonUser : BaseArchiveModel

singleton_interface(SingletonUser)

//  用户信息
@property (nonatomic,strong)UserInfo *userInfo;
//  关联的银行卡
@property (nonatomic,strong)BindedBankCard *bindedBankCard;
//  用户绑定银行卡列表
@property(nonatomic,strong)NSArray *userBankCardList;
//  用户账户管理
@property (nonatomic,strong)UserAccount *userAccount;
//  证明
@property (nonatomic,strong)UserCertify *userCertify;
//  用户统计数据
@property (nonatomic,strong)UserStatistics *userStatistics;

//  我的关注数
//@property (nonatomic,assign)NSInteger isMyFollow;
//  我的好友数
//@property (nonatomic,assign)NSInteger isMyFriend;

//  登陆之后服务器返回(用户判断当前用户是否登陆)
@property (nonatomic,copy)NSString *sessionKey;

/**************************************************/
//  自动登陆密码（扩展属性）  暂未使用
@property (nonatomic,copy)NSString *autoLoginPWD;

//  偏好设置（0：男 1：女 2：图书）
@property (nonatomic,assign)NSInteger likeType;

#pragma mark 归档用户文件数据操作
/*!
 * 判断用户归档文件是否存在
 */
+(BOOL)isExistInPath;
/*!
 * 清空单例用户信息
 */
+(void)clearUserDetail;
/*!
 * 删除用户归档文件
 */
+(BOOL)removeFileAtPath;
/*!
 * 用户信息归档
 */
-(BOOL)saveToFile;
/*!
 * 从本地文件获取用户信息
 */
+(void)getUserFromLocaFile;


/**
 *  检查用户是否已经注册
 */
+(BOOL)checkUserIsExist:(NSString *)userId;

/**
 *  获取已注册的用户信息
 */
+(UserInfo *)getUserInfoIfExist:(NSString *)userId;

/**
 *  用户注册
 */
+(void)userRegisterAction:(NSString *)userName userId:(NSString *)userId pwd:(NSString *)pwd complete:(void(^)(BOOL success))complete;

/**
 *  用户登录
 */
+(void)userLoginAction:(NSString *)userId pwd:(NSString *)pwd complete:(void(^)(BOOL success))complete;

@end
