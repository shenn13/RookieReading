//
//  FilterHeaderView.h
//  topLicaiPro
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterHeaderViewDelegate <NSObject>

-(void)didSelectMenuChange:(NSInteger)index;

@end

@interface FilterHeaderView : UITableViewHeaderFooterView

/**
 *  筛选：全部、精华
 */
@property (nonatomic,strong)UILabel *headerTitle;

@property (nonatomic,strong)UIButton *btnFilter;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,weak)id<FilterHeaderViewDelegate> delegate;

+(FilterHeaderView *)filterHeader:(UITableView *)tableView;

@end
