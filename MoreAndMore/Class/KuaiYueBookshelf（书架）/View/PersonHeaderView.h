//
//  PersonHeaderView.h
//  topLicaiPro
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KuaiKanInfoModel.h"
#import "TextAuthor.h"

#define kHeaderHeight           280.f
#define KBottomHeight           40.f
#define kHeaderMinShowHeight    104.f  // 40.f + 64.f

@class PersonHeaderView;
@protocol PersonHeaderViewDelegate <NSObject>

-(void)headerView:(PersonHeaderView *)headerView barItemClick:(BarItemPosition)positin;

-(void)headerView:(PersonHeaderView *)headerView bottomMenuClick:(BarItemPosition)position;

@end

@interface PersonHeaderView : UIView

+(PersonHeaderView *)headerVew;

@property (nonatomic,strong)KuaiKanInfoModel *kuaiKanModel;

@property (nonatomic,strong)TextAuthor *author;

@property (nonatomic,strong)UserInfo *info;

@property (nonatomic,weak)id<PersonHeaderViewDelegate> delegate;

/**
 *  导航栏部分
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;


-(void)configStyleAlpha:(CGFloat)alpha;

@end
