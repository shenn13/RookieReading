//
//  ReviewBookCell.h
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BookReviewModel.h"

@interface ReviewBookCell : UITableViewCell

+(ReviewBookCell *)reviewCell:(UITableView *)tableView;

@property (nonatomic,strong)BookReviewModel *reviewModel;

@end
