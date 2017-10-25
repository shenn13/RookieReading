//
//  CollectionHeaderReusableView.h
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;

@protocol CollectionHeaderSortDelegate <NSObject>

-(void)clickSortActionWithStatus:(BOOL)isAesc; // 是否是升序

@end

@interface CollectionHeaderReusableView : UICollectionReusableView
/**
 *  控件
 */

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
//这个ImageView用来减少计算量，只计算一次，通过alpha通道调整虚化程度
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *titleContentView;

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@property (weak, nonatomic) IBOutlet UIButton *btnSort;

/**
 *  数据模型
 */

@property (nonatomic, strong) Topic *book;

@property (nonatomic, weak) id<CollectionHeaderSortDelegate> delegate;

/**
 *  界面相关
 */
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat maskValue;


@end
