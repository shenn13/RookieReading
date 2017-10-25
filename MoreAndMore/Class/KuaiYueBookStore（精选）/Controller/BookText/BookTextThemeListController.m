//
//  BookTextThemeListController.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextThemeListController.h"

#import "BookTextDetailController.h"
#import "PersonalCenterController.h"

#import "ThemeBookListModel.h"

#import "ThemeHeaderCell.h"
#import "ThemeBookCell.h"

@interface BookTextThemeListController ()

@property (nonatomic,strong)ThemeBookListModel *themeListModel;

@end

@implementation BookTextThemeListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.recommend.title.length > 0 ? self.recommend.title : @"主题书单";
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    
    [self textThemeBookRequest];
}

-(void)textThemeBookRequest
{
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.recommend.idd.length < 1) {
        [self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉/n该主题书单不存在或已被删除！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [param setObject:self.recommend.idd forKey:@"bookThemeId"];
    // 默认查六条推荐书单
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfSix param:param] requestType:RequestTypeOfZhuiShu params:nil completion:^(NSDictionary *responseObject) {
        if (SUCCESS_OK)
        {
            weakSelf.themeListModel = [ThemeBookListModel toThemeBookListModel:responseObject[@"bookList"]];
            
            if (weakSelf.themeListModel.books.count < 1)
            {
                [weakSelf showTextWithState:ActivityHUDStateFailed inView:weakSelf.navigationController.view text:@"很抱歉\n该书单已被删除!"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.themeListModel.books.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            // 简介
            UITableViewCell *product = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            product.textLabel.numberOfLines = 0;
            product.textLabel.textColor = [UIColor grayColor];
            product.textLabel.font = [UIFont systemFontOfSize:15];
            NSString *message = [NSString stringWithFormat:@"%@",self.themeListModel.desc? self.themeListModel.desc : @"什么都没留！"];
            product.textLabel.text = message;
            return product;
        }
        ThemeHeaderCell *headerCell = [ThemeHeaderCell themeHeaderCell:tableView];
        headerCell.listModel = self.themeListModel;
        return headerCell;
    }
    
    ThemeBookCell *bookCell = [ThemeBookCell themeBookCell:tableView];
    bookCell.bookModel = self.themeListModel.books[indexPath.section - 1];
    return bookCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            return UITableViewAutomaticDimension;
        }
        return 90;
    }
    
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        PersonalCenterController *person = [[PersonalCenterController alloc] init];
        person.appType = AppApiTypeOfZhuiShu;
        person.author = self.themeListModel.author;
        person.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:person animated:YES];
    }
    
    if (indexPath.section != 0)
    {
        ThemeBookModel *bookModel = self.themeListModel.books[indexPath.section - 1];
        
        BookTextDetailController *textDetail = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
        textDetail.textBook = bookModel.book;
        textDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:textDetail animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
