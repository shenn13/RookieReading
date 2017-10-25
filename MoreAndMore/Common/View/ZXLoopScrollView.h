//
//  ZXLoopScrollView.h
//  MoreAndMore
//
//  Created by Silence on 16/6/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertModel.h"
#import "Banner.h"

@class ZXLoopScrollView;
@protocol ZXLoopScrollViewDelegate <NSObject>

-(void)loopScrollView:(ZXLoopScrollView *)loopView clickIndex:(NSInteger)index;

@end

@interface ZXLoopScrollView : UICollectionReusableView

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic,weak)id<ZXLoopScrollViewDelegate> delegate;

@end
