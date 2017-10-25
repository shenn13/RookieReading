//
//  CBReaderView.h
//  MoreAndMore
//
//  Created by apple on 2017/2/27.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBReaderView : UIView

@property(nonatomic,copy)NSString *text;

@property(nonatomic,copy)void(^ReaderViewTapAction)(void);

+(CGRect)textContentRect;

@end
