//
//  MyUserCenterController.m
//  MoreAndMore
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MyUserCenterController.h"

#import "PersonalCenterController.h"
#import "BookshelfViewController.h"
#import "MyLikeSettingViewController.h"
#import "ChangeUserInfoController.h"

#import "SDImageCache.h"

@interface MyUserCenterController ()<MyLikeSettingViewControllerDelegate>

/**
 *  表头
 */
@property (weak, nonatomic) IBOutlet UIView *headerView;
/**
 *  导航栏右边按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
/**
 *  用户区域
 */
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIImageView *imaIcon;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UILabel *labProduct;
/**
 *  扩展区域
 */
@property (weak, nonatomic) IBOutlet UIButton *btnExt;
@property (weak, nonatomic) IBOutlet UILabel *labExt;

/**
 *  节尾
 */
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;

@end

@implementation MyUserCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imaIcon.layer.borderColor = THEME_COLOR.CGColor;
    self.imaIcon.layer.borderWidth = 1.f;
    
    // 导航右边设置按钮暂不需要
    self.btnRight.hidden = YES;
    
    self.btnLoginOut.hidden = YES;
    
    SingletonUser *user = [SingletonUser sharedSingletonUser];
    
    if (user.sessionKey.length > 0)
    {
        self.labUserName.textColor = THEME_COLOR;
        self.labUserName.text = user.userInfo.userName;
        
        UIImage *defImage = [SingletonUser sharedSingletonUser].userInfo.userIconImage ? [SingletonUser sharedSingletonUser].userInfo.userIconImage : DEFAULT_ICON;
        
        [self.imaIcon sd_setImageWithURL:[NSURL URLWithString:[SingletonUser sharedSingletonUser].userInfo.avatar] placeholderImage:defImage];
        
        self.labProduct.text = user.userInfo.signature.length > 0 ? user.userInfo.signature : @"这家伙很懒，什么都没留下！";
        
        self.labExt.text = @"修改个人资料";
        
        self.btnLoginOut.hidden = NO;
        [self.btnLoginOut setTitle:[NSString stringWithFormat:@"退出登录(%@)",user.userInfo.userName]forState:UIControlStateNormal];
    }
    else
    {
        [self.imaIcon setImage:DEFAULT_ICON];
    }
}

#pragma mark - 退出登录事件
- (IBAction)loginOutAction:(UIButton *)sender
{
    kSelfWeak;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否确认退出登录?" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
    [sheet showWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0)
        {
            [weakSelf startActivityWithText:@"退出登录"];
            [weakSelf syncTaskOnMain:^{
                [SingletonUser clearUserDetail];
                [SingletonUser removeFileAtPath];
                LOGINNEED_ACTION;
            } after:1];
        }
    }];
}

#pragma mark - 导航栏左按钮点击事件
- (IBAction)btnLeftClickAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 导航栏右按钮点击事件
- (IBAction)btnRightClickAction:(UIButton *)sender
{
    LOGINNEED_ACTION;
}

#pragma mark - 用户头像区域点击事件
- (IBAction)btnUserClickAction:(UIButton *)sender
{
    LOGINNEED_ACTION;
    
    PersonalCenterController *personVC = [[PersonalCenterController alloc] init];
    personVC.isMee = YES;
    personVC.atUserId = [SingletonUser sharedSingletonUser].userInfo.userId;
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - 扩展按钮点击事件
- (IBAction)btnExtClickAction:(UIButton *)sender
{
    LOGINNEED_ACTION;
    
    // 修改个人资料
    ChangeUserInfoController *changeInfo = BoardVCWithID(@"My", @"CHANGE_USERINFO");
    changeInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeInfo animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        LOGINNEED_ACTION;
    }
    
    if (indexPath.section == 0)
    {
        // 我的收藏
        BookshelfViewController *bookShelf = [[BookshelfViewController alloc] init];
        bookShelf.isFromUserCenter = YES;
        bookShelf.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookShelf animated:YES];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // 阅读偏好设置
            MyLikeSettingViewController *likeSetting = BoardVCWithID(@"Main", @"MYLIKE_VC");
            likeSetting.hidesBottomBarWhenPushed = YES;
            likeSetting.delegate = self;
            [self.navigationController pushViewController:likeSetting animated:YES];
        }
        // 修改密码
        // 意见反馈
    }
    else  if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            // 推荐给朋友
            [self showShareViewWithAppInfo];
        }
        else if (indexPath.row == 1)
        {
            // 清除缓存
            int byteSize = (int)[SDImageCache sharedImageCache].getSize;
            //MB大小
            CGFloat cacheSize = byteSize / 1000.0 / 1000.0;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"缓存大小%.1fM",cacheSize] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认清空缓存" otherButtonTitles:nil];
            [actionSheet showWithCompleteBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0)
                {
                    //清除缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                }
            }];
        }
        // 关于菜鸟
    }
}

#pragma mark - 展示分享视图
-(void)shareViewDidClickShare:(ShareType)shareType
{
    SSDKPlatformType type;
    if (shareType == ShareTypeOfWXTimeLine) {
        type = SSDKPlatformSubTypeWechatTimeline;
    }else if (shareType == ShareTypeOfWeiChat){
        type = SSDKPlatformSubTypeWechatSession;
    }else if (shareType == ShareTypeOfQQ){
        type = SSDKPlatformSubTypeQQFriend;
    }else if(shareType == ShareTypeOfWeiBo){
        type = SSDKPlatformTypeSinaWeibo;
    }
    [self shareToPlatform:type url:[NSURL URLWithString:@"http://www.cnblogs.com/silence-wzx/"] image:[UIImage imageNamed:@"kuaiyue_icon 512"] title:@"菜鸟阅读！" text:@"读万卷书,行万里路！"];
}

-(void)myLikeSettingChangeAction:(MyLikeType)likeType
{
    [self showTextWithState:ActivityHUDStateSuccess inView:self.view text:@"修改偏好设置成功！"];
}

+(void)showUserCenterWithAnimation:(BOOL)animation
{
    __weak MyUserCenterController *userCenter = BoardVCWithID(@"My", @"MY_USERCENTER");
    userCenter.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userCenter];
    nav.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];

    UIViewController *VC = [ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation.topViewController;

    [VC presentViewController:nav animated:animation completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.f;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont systemFontOfSize:14.f];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 刷新昵称
    if ([SingletonUser sharedSingletonUser].sessionKey.length > 0)
    {
        self.labUserName.text = [SingletonUser sharedSingletonUser].userInfo.userName;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
}

@end
