//
//  UIView+Block.h
//  FenQiBao
//
//  Created by gejiangs on 15/1/6.
//  Copyright (c) 2015年 DaChengSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIView (Block)<UIAlertViewDelegate,UIActionSheetDelegate>

/*!
 * 用Block的方式回调，这时候会默认用self作为Delegate
 */
- (void)showWithCompleteBlock:(CompleteBlock)block;

@end
