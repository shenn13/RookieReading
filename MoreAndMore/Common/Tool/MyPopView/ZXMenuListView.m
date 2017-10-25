//
//  ZXMenuListView.m
//  topLicaiPro
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "ZXMenuListView.h"

#define ROE_HEI  44

@interface ZXMenuListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic,assign)BOOL isAnimation;

@property (nonatomic,assign)CGFloat tableHei;

/**
 *  当前选中的脚标
 */
@property (nonatomic,assign)NSInteger index;

@end

@implementation ZXMenuListView

+(ZXMenuListView *)menuWithTitleAry:(NSArray *)ary index:(NSInteger)index
{
    if (ary.count < 1) return nil;
    
    ZXMenuListView *menuView = [[ZXMenuListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    menuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    // 背景
    UIView *backView = [[UIView alloc] initWithFrame:menuView.frame];
    backView.backgroundColor = [UIColor clearColor];
    // 背景手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:menuView action:@selector(backTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backView addGestureRecognizer:tap];
    [menuView addSubview:backView];
    
    // 数据源
    menuView.dataSource = ary;
    menuView.index = index;
    NSInteger maxCount = MIN(8, ary.count);
    menuView.tableHei = ROE_HEI * maxCount;

    // 表格内容
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - menuView.tableHei, SCREEN_WIDTH,0) style:UITableViewStyleGrouped];
    tableView.delegate = menuView;
    tableView.dataSource = menuView;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0.1)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0)];
    tableView.rowHeight = ROE_HEI;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25];
    
    tableView.alpha = 0;
    
    [menuView addSubview:tableView];
    menuView.tableView = tableView;

    return menuView;
}

-(void)showOrHiidenMenuView:(BOOL)isHidden offsetY:(CGFloat)Y
{
    if (self.isAnimation)return;
    
    self.tableView.originY = Y;
    if (!isHidden) {
        [self removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    CGFloat height = isHidden ? 0 : self.tableHei;
    CGFloat alpha = isHidden ? 0 : 1;
    
    self.isAnimation = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.height = height;
        self.tableView.alpha = alpha;
    } completion:^(BOOL finished) {
        if(finished){
            self.isAnimation = NO;
            if (isHidden) {
                [self removeFromSuperview];
            }
        }
    }];
}

#pragma mark UITableViewDelegate和UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    id obj = self.dataSource[indexPath.row];
    if ([obj isKindOfClass:[NSString class]])
    {
        cell.textLabel.text = obj;
    }
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (indexPath.row == self.index)
    {
        UIColor *color = THEME_COLOR;
        cell.tintColor = color;
        cell.textLabel.textColor = color;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.index = indexPath.row;
    
    [_tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(resultListViewDidSelectRow:)])
    {
        [self.delegate resultListViewDidSelectRow:indexPath.row];
    }
    // 隐藏
    [self showOrHiidenMenuView:YES offsetY:tableView.originY];
}


-(void)backTapAction:(UITapGestureRecognizer *)tap
{
    
    if ([self.delegate respondsToSelector:@selector(cancelListView)])
    {
        [self.delegate cancelListView];
    }
    // 移除
    [self showOrHiidenMenuView:YES offsetY:self.tableView.originY];
}

@end
