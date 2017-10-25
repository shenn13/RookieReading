//
//  RecomendTextBookCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecommendBookModel.h"

@interface RecomendTextBookCell : UITableViewCell

+(RecomendTextBookCell *)recomendCell:(UITableView *)tableView;

@property (nonatomic,strong)RecommendBookModel *recommentBook;

@end
