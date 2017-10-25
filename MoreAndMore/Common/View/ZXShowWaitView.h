//
//  ZXShowWaitView.h
//  MoreAndMore
//
//  Created by Silence on 16/6/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MONActivityIndicatorView;

@interface ZXShowWaitView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MONActivityIndicatorView *indicatorView;


- (void)showError;
- (void)showWait;
- (void)removeNotifacationServer;

- (instancetype)initWithOperation:(void(^)())operation;

@end
