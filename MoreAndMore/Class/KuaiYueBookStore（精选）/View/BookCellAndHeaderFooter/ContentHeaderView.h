//
//  ContentHeaderView.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentHeaderView;
@protocol ContentHeaderViewDelegate <NSObject>

-(void)didSelectMoreAction:(ContentHeaderView *)headerView;

@end

@interface ContentHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (nonatomic,weak) id<ContentHeaderViewDelegate> delegate;

@end
