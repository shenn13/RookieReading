//
//  UIViewController+TopShareView.h
//  topLicaiPro
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCustomActionSheet.h"

#import <ShareSDK/ShareSDK.h>

typedef NS_ENUM(NSInteger,ShareType){
    ShareTypeOfWXTimeLine = 1,  // 微信朋友圈
    ShareTypeOfWeiChat, // 微信好友
    ShareTypeOfQQ,  // QQ
    ShareTypeOfWeiBo,  // 新浪微博
    ShareTypeOfOther  // 其他
};

@protocol TopShareDelegate <NSObject>

-(void)shareViewDidClickShare:(ShareType)shareType;

@end

@interface UIViewController (TopShareView)<TopShareDelegate>

#pragma mark - 展示分享视图
// 设置界面分享（微信、QQ、新浪)
-(void)showShareViewWithAppInfo;

#pragma mark ShareSDK分享
-(void)shareToPlatform:(SSDKPlatformType)type url:(NSURL *)url image:(id)image title:(NSString *)title text:(NSString *)text;

@end
