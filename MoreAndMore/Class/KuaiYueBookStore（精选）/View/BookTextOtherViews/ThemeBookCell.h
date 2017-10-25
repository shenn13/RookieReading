//
//  ThemeBookCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThemeBookModel.h"

@interface ThemeBookCell : UITableViewCell

@property (nonatomic,strong)ThemeBookModel *bookModel;

+(ThemeBookCell *)themeBookCell:(UITableView *)tableView;

@end
