//
//  ThemeHeaderCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThemeBookListModel.h"

@interface ThemeHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDes;

@property (nonatomic,strong)ThemeBookListModel *listModel;

+(ThemeHeaderCell *)themeHeaderCell:(UITableView *)tableiView;

@end
