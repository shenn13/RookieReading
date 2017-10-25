//
//  BookSelectHeader.h
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookSelectHeaderDelegate <NSObject>

// 展示简介
-(void)didClickShowProduct:(BOOL)show;

@end

@interface BookSelectHeader : UICollectionReusableView

// 是否展示简介界面
-(void)configShowProduct:(BOOL)show;

@property (nonatomic,weak)id<BookSelectHeaderDelegate> deleagate;

@end
