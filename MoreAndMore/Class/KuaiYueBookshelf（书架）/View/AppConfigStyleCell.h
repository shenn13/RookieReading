//
//  AppConfigStyleCell.h
//  topLicaiPro
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppConfigStyleCell : UITableViewCell

@property (nonatomic,weak)UILabel *labTitle;

+(AppConfigStyleCell *)configCell:(UITableView *)tableView;

+(CGFloat)rowHeight;

@end
