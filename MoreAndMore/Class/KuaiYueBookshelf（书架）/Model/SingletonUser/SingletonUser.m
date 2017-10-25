//
//  SingletonUser.m
//  schoolfriends
//
//  Created by Silence on 16/3/30.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "SingletonUser.h"

#import "MJExtension.h"


@implementation SingletonUser

singleton_implementation(SingletonUser)

#pragma mark 归档用户文件数据操作
+(BOOL)isExistInPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:USER_PATH])
    {
        return YES;
    }
    return NO;
}

/*!
 * 清空单例用户信息
 */
+(void)clearUserDetail
{
    SingletonUser *shareUser = [SingletonUser sharedSingletonUser];
    shareUser.userInfo = nil;
    shareUser.userAccount = nil;
    shareUser.bindedBankCard = nil;
    shareUser.userBankCardList = nil;
    shareUser.userStatistics = nil;
    shareUser.userCertify = nil;
    shareUser.sessionKey = nil;
    shareUser.autoLoginPWD = nil;
    
    //shareUser.isMyFollow = 0;
    //shareUser.isMyFriend = 0;
}

+(BOOL)removeFileAtPath
{
    [SingletonUser clearUserDetail];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag;
    if ([SingletonUser isExistInPath])
    {
        flag = [fileManager removeItemAtPath:USER_PATH error:nil];
        NSLog(@"删除用户归档文件");
    }
    return flag;
}

-(BOOL)saveToFile
{
    NSLog(@"用户归档:%@ %@  %@",USER_PATH,self,self.userInfo);
    // 归档用户信息数据
    NSString *userInfoPath = [SingletonUser getUserInfoPath:self.userInfo.userId];
    
    return [NSKeyedArchiver archiveRootObject:self.userInfo toFile:userInfoPath] && [NSKeyedArchiver archiveRootObject:self toFile:USER_PATH];
}

+(void)getUserFromLocaFile
{
    // 读取本地用户信息
    SingletonUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:USER_PATH];
    NSLog(@"读取本地数据成功：《%@》",user.userInfo.userId);
}

+(BOOL)checkUserIsExist:(NSString *)userId
{
    NSString *userInfoPath = [SingletonUser getUserInfoPath:userId];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:userInfoPath];
}

+(UserInfo *)getUserInfoIfExist:(NSString *)userId
{
    UserInfo *info = nil;
    if ([SingletonUser checkUserIsExist:userId])
    {
        NSString *userInfoPath = [SingletonUser getUserInfoPath:userId];
        
        info = [NSKeyedUnarchiver unarchiveObjectWithFile:userInfoPath];
    }
    return info;
}

#pragma mark - 获取用户信息归档路径
+(NSString *)getUserInfoPath:(NSString *)userId
{
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",userId]];
}

+(void)userRegisterAction:(NSString *)userName userId:(NSString *)userId pwd:(NSString *)pwd complete:(void (^)(BOOL))complete
{
    __weak SingletonUser *user = [SingletonUser sharedSingletonUser];
    
    [user startActivityWithText:@"正在注册\n请稍等!"];
    
    // 获取已经注册的用户信息
    UserInfo *info = [SingletonUser getUserInfoIfExist:userId];
    
    [user syncTaskOnMain:^{
        if ([info.userId isEqualToString:userId])
        {
            [user stopActivityWithText:@"用户已存在,请直接登录!" state:ActivityHUDStateSuccess];
            if (complete) {
                complete(YES);
            }
            return ;
        }
        else if (userName.length < 1 || userId.length < 1 || pwd.length < 1)
        {
            [user stopActivityWithText:@"昵称、账号或密码不能为空!" state:ActivityHUDStateFailed];
        }
        else
        {
            if (info == nil)
            {
                UserInfo *newInfo = [[UserInfo alloc] init];
                newInfo.userName = userName;
                newInfo.userId = userId;
                newInfo.phone = userId;
                newInfo.loginPwd = pwd;
                newInfo.signature = @"这家伙很懒，什么都没留下";
                newInfo.userIconImage = DEFAULT_ICON;
                newInfo.backIconImage = [UIImage imageNamed:@"MIDAUTUMNIMAGE"];
                
                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
                newInfo.updateTime = timeInterval;
                newInfo.createTime = timeInterval;
                newInfo.appType = 2;
                newInfo.registerFrom = 2;
                
                // 头像
                NSArray *iconAry = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ICON_ARRAY" ofType:@"plist"]];
                NSInteger flag = arc4random()%(iconAry.count - 1)+0;
                
                NSString *avater = @"";
                if (flag < iconAry.count) {
                    avater = iconAry[flag];
                }
                newInfo.avatar = avater;
                
                BOOL result = [NSKeyedArchiver archiveRootObject:newInfo toFile:[SingletonUser getUserInfoPath:userId]];
                
                NSLog(@"注册成功：《%@》",newInfo);
                
                NSString *message = result ? @"注册成功!" : @"注册失败！";
                
                if (complete) {
                    complete(result);
                }
                [user stopActivityWithText:message state:result];
                return;
            }
            [user stopActivityWithText:@"未知错误!" state:ActivityHUDStateFailed];
        }
        // 回调block
        if (complete) {
            complete(NO);
        }

    } after:1];
}

+(void)userLoginAction:(NSString *)userId pwd:(NSString *)pwd complete:(void(^)(BOOL success))complete
{
    __weak SingletonUser *user = [SingletonUser sharedSingletonUser];
    
    [user startActivityWithText:@"正在登录\n请稍等!"];
    
    // 获取已经注册的用户信息
    UserInfo *info = [SingletonUser getUserInfoIfExist:userId];
    
    [user syncTaskOnMain:^{
        if (info != nil && [info.userId isEqualToString:userId])
        {
            if (![info.loginPwd isEqualToString:pwd])
            {
                [user stopActivityWithText:@"登录失败\n密码错误!" state:ActivityHUDStateFailed];
                return ;
            }
            user.userInfo = info;
            user.userInfo.loginPwd = pwd;
            user.autoLoginPWD = pwd;
            user.sessionKey = @"kuaiyue_sessionkey_silence";
            // 登录成功归档数据
            [user saveToFile];
            // 回调block
            if (complete) {
                complete(YES);
            }
            NSLog(@"登录成功：《%@》",user);
            
            [user stopActivityWithText:@"登录成功!" state:ActivityHUDStateSuccess];
            return;
        }
        
        if (userId.length < 1 || pwd.length < 1)
        {
            [user stopActivityWithText:@"账号或密码不能为空!" state:ActivityHUDStateFailed];
        }
        else if (info == nil)
        {
            [user stopActivityWithText:@"登录失败\n账号或密码错误!" state:ActivityHUDStateFailed];
        }
        else
        {
            [user stopActivityWithText:@"未知错误!" state:ActivityHUDStateFailed];
        }
        // 回调block
        if (complete) {
            complete(NO);
        }
    } after:1];
}

@end
