//
//  FilterHeaderView.m
//  topLicaiPro
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "FilterHeaderView.h"

#import "ZXMenuListView.h"

@interface FilterHeaderView ()<ZXMenuListViewDelegate>

@property (nonatomic,strong)ZXMenuListView *listView;;

@property (nonatomic,weak)UITableView *tableView;

@end

@implementation FilterHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        // 标题
        UILabel *headerTitle = [[UILabel alloc] init];
        headerTitle.font = [UIFont systemFontOfSize:15];
        [backView addSubview:headerTitle];
        
        // 筛选按钮
        UIButton *btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFilter.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnFilter addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *norImg = [UIImage imageNamed:@"top_arrow"];
        UIImage *selImg = [UIImage imageNamed:@"down_arrow"];
        
        [btnFilter setImage:norImg forState:UIControlStateNormal];
        [btnFilter setImage:selImg forState:UIControlStateSelected];
        btnFilter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btnFilter.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btnFilter setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [backView addSubview:btnFilter];
        btnFilter.hidden = YES;
        
        self.headerTitle = headerTitle;
        self.btnFilter = btnFilter;
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [btnFilter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(backView.mas_height);
            make.centerY.mas_equalTo(0);
        }];
        
        [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(btnFilter.mas_left);
        }];
    }
    return self;
}

+(FilterHeaderView *)filterHeader:(UITableView *)tableView
{
    static NSString *identifier = @"FILTER_HEADER";
    
    FilterHeaderView *filter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!filter) {
        filter = [[FilterHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    filter.tableView = tableView;
    return filter;
}

-(void)filterAction:(UIButton *)btnFilter
{
    // 展示菜单项
    CGRect rect = [self.superview convertRect:self.frame toView:WINDOW];

    [self.listView showOrHiidenMenuView:NO offsetY:CGRectGetMaxY(rect)];
    
    [btnFilter setSelected:YES];
}

#pragma mark - ZXMenuListViewDelegate代理

-(void)resultListViewDidSelectRow:(NSInteger)index
{
    [self.btnFilter setSelected:NO];
    
    if (index != self.currentIndex && [self.delegate respondsToSelector:@selector(didSelectMenuChange:)])
    {
        [self.delegate didSelectMenuChange:index];
    }
    
    self.currentIndex = index;
    [self.tableView reloadData];
}

-(void)cancelListView
{
    [self.btnFilter setSelected:NO];
}

-(ZXMenuListView *)listView
{
    if (!_listView) {
        _listView = [ZXMenuListView menuWithTitleAry:@[@"全部",@"精华"] index:0];
        _listView.delegate = self;
    }
    return _listView;
}

@end
