//
//  CBReaderInfoTool.h
//  MoreAndMore
//
//  Created by apple on 2017/2/28.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 阅读页底部栏:
 1.章节标题
 2.电池信息
 3.……
 */
@interface CBReaderInfoTool : UIView

@property (nonatomic,copy)NSString *chalpterTitle;

+(CGRect)infoToolRect;

@end
