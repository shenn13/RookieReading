//
//  BookTextContentView.h
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BookTextRanking.h"

@interface BookTextContentView : UICollectionView

/**
 *  男士
 */
@property (nonatomic,strong)NSMutableArray *maleRankList;

/**
 *  女士（暂未使用）
 */
@property (nonatomic,strong)NSMutableArray *femaleRankList;

@property (nonatomic,strong)NSMutableArray *dataAry;

@property (nonatomic,strong)CALayer *topLayer;

@end
