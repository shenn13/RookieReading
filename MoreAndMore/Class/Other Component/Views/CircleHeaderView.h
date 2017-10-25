//
//  CircleHeaderView.h
//  WCLDConsulting
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

typedef NS_ENUM(NSInteger,CircleHeaderViewActionType){
    CircleHeaderViewActionOfIcon,  // 头像
    CircleHeaderViewActionOfName,  // 昵称
    CircleHeaderViewActionOfTextContent, // 文本内容
    CircleHeaderViewActionOfLink  // 超链接
};

#define TOP_ICON_WH 40

@class SDTimeLineCellModel;
@interface CircleHeaderView : UIView<MLEmojiLabelDelegate>

@property (nonatomic, strong) SDTimeLineCellModel *topModel;

@property (nonatomic, copy) void (^circleHeaderViewBlock)(CircleHeaderViewActionType type);

@property (nonatomic, copy) void (^openOrCloseTextContentBlock)(void);

@property (nonatomic, copy) void (^headerContentLinkTypeBlock)(MLEmojiLabelLinkType type,NSString *linkText,NSString *linkValue);

@end
