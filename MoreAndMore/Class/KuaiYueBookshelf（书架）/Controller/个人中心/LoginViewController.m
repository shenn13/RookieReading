//
//  LoginViewController.m
//  MoreAndMore
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "LoginViewController.h"

#import "LoginInputView.h"
#import "RegisterInputView.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *inputContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UILabel *labExt;




@property (nonatomic,assign)BOOL isLogin;

// 登录输入框
@property (nonatomic,strong)LoginInputView *loginView;
// 注册输入框
@property (nonatomic,strong)RegisterInputView *registerView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.title = @"登录";
    
    self.inputContentView.layer.borderColor = LINE_COLOR.CGColor;
    self.inputContentView.layer.borderWidth = 1.f;
    
    self.isLogin = NO;
    
    // 登录成功回调block
    kSelfWeak;
    [[NSNotificationCenter defaultCenter] addObserverForName:LOGIN_SUCCESS object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf dismissOrPopBack];
    }];
}

#pragma mark - 两大按钮点击

- (IBAction)btnRegisterAction:(UIButton *)sender
{
    if (self.isLogin == NO)
    {
        if (![self checkRegisterInput]) return;
        
        [SingletonUser userRegisterAction:self.registerView.txfRegisterName.text userId:self.registerView.txfRegisterAccount.text pwd:self.registerView.txfRegisterPwd.text complete:^(BOOL success) {
            if (success)
            {
                self.registerView.txfRegisterAccount.text = @"";
                self.registerView.txfRegisterName.text = @"";
                self.registerView.txfRegisterPwd.text = @"";
                self.isLogin = YES;
            }
        }];
        return;
    }
    self.isLogin = NO;
}

- (IBAction)btnLoginAction:(UIButton *)sender
{
    if (self.isLogin == YES)
    {
        // 检查登录数据输入有效性
        if (![self checkLoginInput]) return;
        // 调用登录接口
        [SingletonUser userLoginAction:self.loginView.txfLoginName.text pwd:self.loginView.txfLoginPwd.text complete:^(BOOL success) {
            if (success)
            {
                self.loginView.txfLoginName.text = @"";
                self.loginView.txfLoginPwd.text = @"";
                // 发送登录成功通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
            }
        }];
        return;
    }
    self.isLogin = YES;
}

-(void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    
    [self.registerView removeFromSuperview];
    [self.loginView removeFromSuperview];
    
    UIColor *themeIconColor = [UIColor colorWithHexString:@"0x2BBF95"];
    
    if (isLogin)
    {
        // 按钮颜色状态切换
        [self.btnRegister setBackgroundColor:[UIColor whiteColor]];
        [self.btnRegister setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self.btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnLogin setBackgroundColor:themeIconColor];
        // 输入框区域改变
        self.inputContentView.sd_layout.heightIs(120.f);
        [self.inputContentView addSubview:self.loginView];
    }
    else
    {
        // 按钮颜色状态切换
        [self.btnRegister setBackgroundColor:themeIconColor];
        [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.btnLogin setTitle:@"已有账号登录" forState:UIControlStateNormal];
        [self.btnLogin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnLogin setBackgroundColor:[UIColor whiteColor]];
        
        // 输入框区域改变
        self.inputContentView.sd_layout.heightIs(150.f);
        [self.inputContentView addSubview:self.registerView];
    }
}

#pragma mark - 页面消失

- (IBAction)btnCloseAction:(UIButton *)sender
{
    [self dismissOrPopBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
}

-(LoginInputView *)loginView
{
    if (!_loginView) {
        _loginView = [LoginInputView loginView];
        _loginView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 48, 120.f);
    }
    return _loginView;
}

-(RegisterInputView *)registerView
{
    if (!_registerView) {
        _registerView = [RegisterInputView registerView];
        _registerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 48, 150.f);
    }
    return _registerView;
}

#pragma mark - 检查注册输入数据

-(BOOL)checkRegisterInput
{
    if (self.registerView.txfRegisterName.text.length < 1)
    {
        [self showText:@"请输入您的昵称!" inView:self.view];
        return NO;
    }
    else if (self.registerView.txfRegisterAccount.text.length < 1)
    {
        [self showText:@"请输入您的手机号码!" inView:self.view];
        return NO;
    }
    else if (self.registerView.txfRegisterPwd.text.length < 1)
    {
        [self showText:@"请输入您的注册密码!" inView:self.view];
        return NO;
    }
    else if (![self.registerView.txfRegisterAccount.text checkMobileNumber])
    {
        [self showText:@"请输入正确的手机号码!" inView:self.view];
        return NO;
    }
    else if (self.registerView.txfRegisterPwd.text.length < 6)
    {
        [self showText:@"请至少输入六位数密码!" inView:self.view];
        return NO;
    }
    return YES;
}

#pragma mark - 检查登录输入数据

-(BOOL)checkLoginInput
{
    if (self.loginView.txfLoginName.text.length < 1)
    {
        [self showText:@"请输入登录账号!\n(手机号码)" inView:self.view];
        return NO;
    }
    else if (self.loginView.txfLoginPwd.text.length < 1)
    {
        [self showText:@"请输入登录密码!" inView:self.view];
        return NO;
    }
    else if (![self.loginView.txfLoginName.text checkMobileNumber])
    {
        [self showText:@"请输入正确的手机号码!" inView:self.view];
        return NO;
    }
    else if (self.loginView.txfLoginPwd.text.length < 6)
    {
        [self showText:@"请至少输入六位数密码!" inView:self.view];
        return NO;
    }
    return YES;
}

@end
