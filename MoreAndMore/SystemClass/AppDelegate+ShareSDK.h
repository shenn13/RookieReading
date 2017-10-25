//
//  AppDelegate+ShareSDK.h
//  schoolfriends
//
//  Created by Silence on 16/4/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

//#import <RennSDK/RennSDK.h>

@interface AppDelegate (ShareSDK)

-(void)registerShareSDK;
 
@end
