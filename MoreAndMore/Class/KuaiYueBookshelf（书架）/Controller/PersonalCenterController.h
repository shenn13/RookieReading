//
//  PersonalCenterController.h
//  topLicaiPro
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "ZXBaseViewController.h"

#import "TextAuthor.h"

@interface PersonalCenterController : ZXBaseViewController

/**
 *  要查看的用户ID
 */
@property (nonatomic,assign)NSString *atUserId;

@property (nonatomic,assign)AppApiType appType;

/**
 *  是否是自己
 */
@property (nonatomic,assign)BOOL isMee;


@property (nonatomic,strong)TextAuthor *author;

@end
