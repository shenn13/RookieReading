//
//  BookStoreBaseCell.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentHeaderView.h"
#import "StoreListModel.h"

#define HEADER_MAR  45
#define MAR         12

static NSString *identifierOne   = @"IdentifierSectionOne";
static NSString *identifierOneSpec = @"identifierSectionOneSpec";
// 每周排行榜
static NSString *identifierTwo   = @"IdentifierSectionTwo";
// 新作出炉
static NSString *identifierThree = @"IdentifierSectionThree";
// 主编力推
static NSString *identifierFour  = @"IdentifierSectionFour";
// 官方活动
static NSString *identifierFive  = @"IdentifierSectionFive";

@interface BookStoreBaseCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ContentHeaderViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, weak) UICollectionViewFlowLayout *contentLayout;

@property (nonatomic,strong)ContentHeaderView *headerView;

@property (nonatomic,strong)StoreListModel *storeModel;

@property (nonatomic,assign,readonly)CGSize itemSize;

// 子类重构
- (void)initCompletionOpration;
- (void)contentModelCompletionOpration;

// 通过重用标识获取尺寸
+(CGSize)itemSizeWithIdentifier:(NSString *)identifier;

@end
