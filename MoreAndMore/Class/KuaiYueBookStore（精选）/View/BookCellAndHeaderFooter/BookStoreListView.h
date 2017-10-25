//
//  BookStoreListView.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZXLoopScrollView.h"
#import "ContentFooterView.h"

#import "FirstBookStoreCell.h"
#import "SecondBookStoreCell.h"
#import "ThirdBookStoreCell.h"
#import "FifthBookStoreCell.h"
#import "FourthBookStoreCell.h"  //V2新样式

@interface BookStoreListView : UICollectionView

/*!
 * 广告栏数据
 */
@property (nonatomic,strong)NSArray *advertArray;
/*!
 * 列表数据
 */
@property (nonatomic,strong)NSArray *listArr;

/**
 *  是新接口
 */
@property (nonatomic,assign)BOOL isFromV2;


@property (nonatomic,strong)CALayer *topLayer;

@end
