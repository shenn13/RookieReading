//
//  ZXBaseTableViewController.m
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"

@interface ZXBaseTableViewController ()

@end

@implementation ZXBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 配置页面风格
    [self configBaseVC];
}

-(void)configBaseVC
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 界面优化
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    UIImage *image = [UIImage imageNamed:@"menu_bk_partten"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //页面没有显示时 导航栏不可点
    self.navigationItem.leftBarButtonItem.customView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
    
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    //默认显示黑线
    blackLineImageView.hidden = [self hideNavigationBottomLine];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.leftBarButtonItem.customView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"页面控制器 （%@） 被销毁了",NSStringFromClass([self class]));
}

#pragma mark - 隐藏导航黑线（子类重写)
-(BOOL)hideNavigationBottomLine
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
