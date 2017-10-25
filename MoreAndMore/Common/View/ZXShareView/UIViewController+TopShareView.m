//
//  UIViewController+TopShareView.m
//  topLicaiPro
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "UIViewController+TopShareView.h"

@interface UIViewController ()<YXCustomActionSheetDelegate>



@end

@implementation UIViewController (TopShareView)

-(void)showShareViewWithAppInfo
{
    NSArray *shareAry = @[@{@"icon":@"share_btn_wxtimeline",
                            @"highlightedImage":@"share_btn_wxtimeline",
                            @"name":@"微信朋友圈",
                            @"isOk":@(YES)},
                          
                          @{@"icon":@"share_btn_wxsession",
                            @"highlightedImage":@"share_btn_wxsession",
                            @"name":@"微信好友",
                            @"isOk":@(YES)},
                          
                          @{@"icon":@"share_btn_qq",
                            @"name":@"QQ",
                            @"isOk":@(YES)},
                          
                          @{@"icon":@"share_btn_sina",
                            @"name":@"新浪微博",
                            @"isOk":@(YES)},
                          ];
    YXCustomActionSheet *shareSheet = [[YXCustomActionSheet alloc] init];
    shareSheet.delegate = self;
    [shareSheet showInView:KEY_WINDOW contentArray:shareAry];
    
}

#pragma mark YXCustomActionSheetDelegate
- (void)customActionSheetButtonClick:(YXActionSheetButton *)button
{
    NSString *title = button.titleLabel.text;
    
    NSLog(@"分享视图点击:%@",title);
    
    ShareType type = [self getShareTypeWithTitle:title];
    
    if (type != ShareTypeOfOther && [self respondsToSelector:@selector(shareViewDidClickShare:)])
    {
        /**
         *  需要分享的页面去实现 【shareViewDidClickShare】 方法
         */
        [self shareViewDidClickShare:type];
    }
}

-(ShareType)getShareTypeWithTitle:(NSString *)title
{
    NSArray *titleArr = @[@"微信朋友圈",@"微信好友", @"QQ", @"新浪微博"];
    if ([title isEqualToString:titleArr[0]])
    {
        return ShareTypeOfWXTimeLine;
    }
    else if ([title isEqualToString:titleArr[1]])
    {
        return ShareTypeOfWeiChat;
    }
    else if ([title isEqualToString:titleArr[2]])
    {
        return ShareTypeOfQQ;
    }
    else if ([title isEqualToString:titleArr[3]])
    {
        return ShareTypeOfWeiBo;
    }
    else
    {
        return ShareTypeOfOther;
    }
}

#pragma mark ShareSDK分享
-(void)shareToPlatform:(SSDKPlatformType)type url:(NSURL *)url image:(id)image title:(NSString *)title text:(NSString *)text
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (type == SSDKPlatformSubTypeWechatTimeline)  // 微信朋友圈
    {
        [shareParams SSDKSetupWeChatParamsByText:text title:title url:url thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    }
    else if (type == SSDKPlatformSubTypeWechatSession)  // 微信好友
    {
        [shareParams SSDKSetupWeChatParamsByText:text title:title url:url thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    }
    else if (type == SSDKPlatformTypeSinaWeibo)  // 微博
    {
        [shareParams SSDKSetupSinaWeiboShareParamsByText:text title:title image:image url:url latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    }
    else if (type == SSDKPlatformSubTypeQQFriend)  // QQ好友
    {
        [shareParams SSDKSetupQQParamsByText:text title:title url:url thumbImage:image image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    }
    /*
    else if (type == SSDKPlatformTypeRenren)  // 人人
    {
        [shareParams SSDKSetupRenRenParamsByText:text image:image url:url albumId:nil type:SSDKContentTypeAuto];
    }
    */
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSString *description;
        NSLog(@"分享回调userData:%@",userData);
        NSLog(@"分享失败信息%@",error);
        if (state == SSDKResponseStateSuccess) {
            description = @"分享成功";
        }else if (state == SSDKResponseStateCancel){
            description = @"取消分享";
        }else if (state == SSDKResponseStateFail){
            NSString *errorMessage = [NSString stringWithFormat:@"%@",error.userInfo[@"error_message"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:errorMessage delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
        if (![description checkEmpty] && description != nil)
        {
            [self showText:description inView:self.view];
        }
    }];
}


@end
