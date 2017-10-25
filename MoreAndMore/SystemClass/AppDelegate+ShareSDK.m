//
//  AppDelegate+ShareSDK.m
//  schoolfriends
//
//  Created by Silence on 16/4/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"

#define ShareAppKey @"112815a347b9a"
#define ShareAppSecret @"aa970c7cad2fceb5b95ed05c3c7e6692"

// 微信（wx5995328b4f41c35d -- b28bcc056aeb28dc588326506267b429）
// NEW（wx503067fd9357c0eb -- 5ad45b60e3a14b0f18ba2890caa5b187）
#define WXAppID @"wx5995328b4f41c35d"
#define WXAppSecret @"b28bcc056aeb28dc588326506267b429"

// 新浪微博 (wb680373142)
/*
 59521072
 680373142 
 c4c0f31c898753b5fa23e54561ef7869
 */
#define WeiBoAppID @"59521072"
#define WeiBoAppAppKey @"680373142"
#define WeiBoAppSecret @"c4c0f31c898753b5fa23e54561ef7869"

// 腾讯（tencent1105258080） 1105258080 3GrzbbITaxrbKE9A
#define QQAppID @"1105258080"
#define QQAppKey @"3GrzbbITaxrbKE9A"

// 人人 (rm482558com.hawode.schoolfriends)
#define RenRenAppID @"482558"
#define RenRenAppKey @"26813b82e45e4f708be1be8f2984033c"
#define RenRenAppSecret @"b090b9928362428fa05d05da0ac0c9d6"

@implementation AppDelegate (ShareSDK)

-(void)registerShareSDK
{
    //@(SSDKPlatformTypeRenren)
    [ShareSDK registerApp:ShareAppKey activePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeAliPaySocial)] onImport:^(SSDKPlatformType platformType) {
        // 需要授权那些平台
        switch (platformType) {
                
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                break;
                
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
                
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
             /*
            case SSDKPlatformTypeRenren:
                [ShareSDKConnector connectRenren:[RennClient class]];
                break;
              */
            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        // 配置授权平台app信息
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:WXAppID appSecret:WXAppSecret];
                break;
                
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:WeiBoAppAppKey appSecret:WeiBoAppSecret redirectUri:@"http://www.baidu.com" authType:SSDKAuthTypeBoth];
                break;
                
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:QQAppID appKey:QQAppKey authType:SSDKAuthTypeBoth];
                break;
             /*
            case SSDKPlatformTypeRenren:
                [appInfo SSDKSetupRenRenByAppId:RenRenAppID appKey:RenRenAppKey secretKey:RenRenAppSecret authType:SSDKAuthTypeBoth];
                break;
              */
            default:
                break;
        }
    }];
}

// 微信回调结果


-(void)onResp:(BaseResp *)resp
{
    NSLog(@"收到一个来自微信的处理结果。");
}

@end
