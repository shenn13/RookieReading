//
//  ChangePWDViewController.m
//  MoreAndMore
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ChangePWDViewController.h"

@interface ChangePWDViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txfOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *txfNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *txfSurePwd;

@end

@implementation ChangePWDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorColor = LINE_COLOR;
    
    self.navigationItem.title = @"修改密码";
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:NO spacer:10 norArr:@[@"确认"] selArr:nil];
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    LOGINNEED_ACTION;
    
    if (self.txfOldPwd.text.length < 1) {
        [self showText:@"原密码不能为空" inView:self.view];
        return;
    }
    if (self.txfNewPwd.text.length < 1 || self.txfSurePwd.text.length < 1) {
        [self showText:@"请输入新密码!" inView:self.view];
        return;
    }
    if (self.txfNewPwd.text.length < 6){
        [self showText:@"新密码至少6位数！" inView:self.view];
        return;
    }
    if (![self.txfNewPwd.text isEqualToString:self.txfSurePwd.text]) {
        [self showText:@"两次密码输入不一致！" inView:self.view];
        return;
    }
    
    [self startActivityWithText:REQUESTTIPING];
    
    kSelfWeak;
    [self syncTaskOnMain:^{
        UserInfo *info = [SingletonUser getUserInfoIfExist:[SingletonUser sharedSingletonUser].userInfo.userId];
        if ([info.loginPwd isEqualToString:self.txfOldPwd.text])
        {
            [SingletonUser sharedSingletonUser]. userInfo.loginPwd = self.txfNewPwd.text;
            [SingletonUser sharedSingletonUser].autoLoginPWD = self.txfNewPwd.text;
            [[SingletonUser sharedSingletonUser] saveToFile];
            
            [SingletonUser clearUserDetail];
            [SingletonUser removeFileAtPath];
            
            [weakSelf stopActivityWithText:@"密码修改成功" state:ActivityHUDStateSuccess];
            
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                LOGINNEED_ACTION;
            }];
            
        }else{
            [weakSelf stopActivityWithText:@"原密码错误!" state:ActivityHUDStateFailed];
        }
    } after:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
@end
