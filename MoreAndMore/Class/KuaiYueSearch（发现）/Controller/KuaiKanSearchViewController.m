//
//  KuaiKanSearchViewController.m
//  MoreAndMore
//
//  Created by Silence on 16/6/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "KuaiKanSearchViewController.h"

#import "BookThemeListController.h"
#import "PublicWebController.h"
#import "BookReviewListController.h"
#import "BookHelpEachOtherController.h"

#import "BookSearchViewController.h"

@interface KuaiKanSearchViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar *searchBar;

@end

@implementation KuaiKanSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.separatorColor = LINE_COLOR;
    
    self.navigationItem.title = @"发现";
    
    // 搜索框
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - UISearchBarDelegate代理

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar

{
    BookSearchViewController *bookSearch = [[BookSearchViewController alloc] init];
    bookSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookSearch animated:NO];
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        // 主题书单
        BookThemeListController *themeListBook = [[BookThemeListController alloc] init];
        themeListBook.menuIndex = 0;
        themeListBook.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:themeListBook animated:YES];
    }
    /*
    else if (indexPath.section == 2)
    {
        // VIP专区
        PublicWebController *public = [[PublicWebController alloc] init];
        public.detailTitle = @"会员中心";
        public.detailURL = @"http://www.cnblogs.com/silence-wzx/";
        public.hidesBottomBarWhenPushed = YES;
        [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:public animated:YES];
    }
    */
    else if (indexPath.section == 2)
    {
        // 书评区
        BookReviewListController *bookReview = [[BookReviewListController alloc] init];
        bookReview.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookReview animated:YES];
    }
    else if (indexPath.section == 3)
    {
        // 书荒互助
        BookHelpEachOtherController *help = [[BookHelpEachOtherController alloc] init];
        help.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:help animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - 懒加载

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入书名/作者名搜索";
        for (UIView *view in _searchBar.subviews[0].subviews)
        {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelBtn = (UIButton *)view;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            }
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)view;
                textField.textColor = [UIColor whiteColor];                         //修改输入字体的颜色
                [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];   //修改placeholder的颜色
            }
        }
    }
    return _searchBar;
}

@end
