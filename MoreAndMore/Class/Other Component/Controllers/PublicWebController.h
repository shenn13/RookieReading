//
//  PublicWebController.h
//  WCLDConsulting
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "ZXBaseViewController.h"

typedef NS_ENUM(NSInteger,ShowHtmlType){
    ShowHtmlTypeOfUS = 1, // 关于我们
    ShowHtmlTypeOfUserRules = 2  // 用户守则
};

@interface PublicWebController : ZXBaseViewController

/**
 *  用于展示一个网页
 */

@property (nonatomic, copy) NSString * detailURL;

@property (nonatomic, copy) NSString * detailTitle;

/**
 *  展示类型（固定：设置showType属性即可）
 */
@property (nonatomic,assign) ShowHtmlType showType;

@end
