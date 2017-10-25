//
//  BookTextBaseCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RankListModel.h"
#import "BookTextRanking.h"

#import "ContentHeaderView.h"

#define HEADER_MAR  45
#define MAR         12

static NSString *identifierOther    = @"OTHER_DEFAULT_CELL";

static NSString *identifierOne_text   = @"IdentifierSectionOne_text";

static NSString *identifierTwo_text   = @"IdentifierSectionTwo_text";

static NSString *identifierThree_text = @"IdentifierSectionThree_text";

static NSString *identifierFour_text  = @"IdentifierSectionFour_text";

static NSString *identifierFive_text  = @"IdentifierSectionFive_text";

@interface BookTextBaseCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, weak) UICollectionViewFlowLayout *contentLayout;

@property (nonatomic,strong)ContentHeaderView *headerView;

@property (nonatomic,strong)RankListModel *rankListModel;

@property (nonatomic,strong)BookTextRanking *ranking;

// 子类重构
- (void)initCompletionOpration;
- (void)contentModelCompletionOpration;

@end
