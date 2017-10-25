//
//  BookDetailView.h
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFComicShowBookLayout.h"
#import "CollectionHeaderReusableView.h"
#import "BookSelectHeader.h"
#import "BookComicCell.h"
#import "ProductCollectionCell.h"

#import "Topic.h"
#import "BookDetail.h"

#define HEADER_HEIGHT           200
#define ITEM_HEIGHT             90
#define HEADER_IDENTIFIER       @"HEADER_IDENTIFIER"
#define BOOK_DETAIL_IDENTIFIER  @"BOOK_IDENTIFIER"
#define SECTION_IDENTIFER       @"SECTION_IDENTIFIER"

@interface BookDetailView : UICollectionView

@property (nonatomic,strong) Topic *book;

@property (nonatomic,strong) BookDetail *detail;

@end
