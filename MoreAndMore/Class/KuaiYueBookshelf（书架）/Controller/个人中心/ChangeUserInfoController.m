//
//  ChangeUserInfoController.m
//  MoreAndMore
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ChangeUserInfoController.h"

@interface ChangeUserInfoController ()

@property (weak, nonatomic) IBOutlet UITextField *txfUserName;

@end

@implementation ChangeUserInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.separatorColor = LINE_COLOR;
    
    self.navigationItem.title = @"个人资料修改";
    
    NSString *userName = [SingletonUser sharedSingletonUser].userInfo.userName.length > 0 ? [SingletonUser sharedSingletonUser].userInfo.userName : @"请输入昵称";
    
    self.txfUserName.placeholder = userName;
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:NO spacer:10 norArr:@[@"确认"] selArr:nil];
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    LOGINNEED_ACTION;
    
    if (self.txfUserName.text.length < 1)
    {
        [self showText:@"昵称不能为空!" inView:self.view];
        return;
    }
    
    [self startActivityWithText:REQUESTTIPING];
    
    kSelfWeak;
    [self syncTaskOnMain:^{
        [SingletonUser sharedSingletonUser].userInfo.userName = self.txfUserName.text;
        [[SingletonUser sharedSingletonUser] saveToFile];
        [weakSelf stopActivityWithText:@"修改个人资料成功！" state:ActivityHUDStateSuccess];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } after:1];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
