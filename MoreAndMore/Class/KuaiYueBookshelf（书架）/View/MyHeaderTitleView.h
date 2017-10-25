//
//  MyHeaderTitleView.h
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MY_HEADERTITLE  @"MY_HEADERTITLE"

@class MyHeaderTitleView;
@protocol MyHeaderTitleViewDelegate  <NSObject>

-(void)MyHeaderRemoveBook:(MyHeaderTitleView *)headerView;

@end

@interface MyHeaderTitleView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@property (nonatomic,assign)BOOL isEdit;

@property (nonatomic,strong)NSIndexPath *index;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;


@property (nonatomic,weak)id<MyHeaderTitleViewDelegate> delegate;

@end
