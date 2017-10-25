//
//  PersonHeaderView.m
//  topLicaiPro
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "PersonHeaderView.h"
#import "ZXJumpToControllerManager.h"
#import "PublicWebController.h"

#import "JKImagePickerController.h"

@interface PersonHeaderView ()<JKImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

/**
 *  个人基本信息部分
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *btnCircle;
@property (weak, nonatomic) IBOutlet UILabel *labOtherMessage;

@property (weak, nonatomic) IBOutlet UIButton *btnSignV;

@property (nonatomic,assign)BOOL isChangeIcon;

/**
 *  底部区域
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnFans;

@end

@implementation PersonHeaderView

-(void)awakeFromNib
{
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgrounImageTapAction:)];
    tapBg.numberOfTouchesRequired = 1;
    tapBg.numberOfTapsRequired = 1;
    [self.backImageView addGestureRecognizer:tapBg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconTapAction:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.iconImage addGestureRecognizer:tap];
    
    [self.topView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"AlbumListViewBkg"]]];
    
    [self.btnCircle setImage:[UIImage imageNamed:@"VIP_Invalid"] forState:UIControlStateNormal];
    self.btnCircle.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

+(PersonHeaderView *)headerVew
{
    PersonHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"PersonHeaderView" owner:nil options:nil][0];
    headerView.backgroundColor = THEME_COLOR;
    
    headerView.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    headerView.bottomView.backgroundColor = [THEME_COLOR colorWithAlphaComponent:0.3];

    return headerView;
}

-(void)configStyleAlpha:(CGFloat)alpha
{
    UIColor *currentColor = [THEME_COLOR colorWithAlphaComponent:alpha];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.topView setBackgroundColor:currentColor];
        
        [self.bottomView setBackgroundColor:currentColor];
    }];
}

-(void)setKuaiKanModel:(KuaiKanInfoModel *)kuaiKanModel
{
    _kuaiKanModel = kuaiKanModel;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:kuaiKanModel.avatar_url] placeholderImage:[UIImage imageNamed:@"default_avater"]];
    
    NSString *userName = kuaiKanModel.nickname;
    if (kuaiKanModel.nickname.length > 10)
    {
        userName = [NSString stringWithFormat:@"%@...",[kuaiKanModel.nickname substringToIndex:10]];
    }
    self.labName.text = userName;
    self.labTitle.text = userName;
    
    self.labOtherMessage.text = kuaiKanModel.u_intro;

    NSString *fansCount = [NSString stringWithFormat:@"粉丝：%ld",kuaiKanModel.follower_cnt];
    NSString *followCount = [NSString stringWithFormat:@"关注：%d",0];
    
    [self.btnFans setTitle:fansCount forState:UIControlStateNormal];
    [self.btnFollow setTitle:followCount forState:UIControlStateNormal];

    if (kuaiKanModel.grade > 0)
    {
        [self.btnCircle setImage:[UIImage imageNamed:@"VIP_Valid"] forState:UIControlStateNormal];
    }
}

-(void)setInfo:(UserInfo *)info
{
    _info = info;
    
    UIImage *defImage = info.userIconImage ? info.userIconImage : DEFAULT_ICON;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:defImage];
    
    UIImage *bgImage = info.backIconImage ? info.backIconImage : [UIImage imageNamed:@"MIDAUTUMNIMAGE"];
    [self.backImageView setImage:bgImage];
    
    self.labName.text = info.userName;
    self.labTitle.text = info.userName;
    
    self.labOtherMessage.text = @"书虫";
    
    NSString *fansCount = [NSString stringWithFormat:@"粉丝：%d",666];
    NSString *followCount = [NSString stringWithFormat:@"关注：%d",666];
    
    [self.btnFans setTitle:fansCount forState:UIControlStateNormal];
    [self.btnFollow setTitle:followCount forState:UIControlStateNormal];
    
    if (info.isAuth > 0)
    {
        [self.btnCircle setImage:[UIImage imageNamed:@"VIP_Valid"] forState:UIControlStateNormal];
    }
}

-(void)setAuthor:(TextAuthor *)author
{
    _author = author;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(author.avatar)] placeholderImage:[UIImage imageNamed:@"default_avater"]];
    
    NSString *userName = author.nickname;
    self.labName.text = userName;
    self.labTitle.text = userName;
    
    self.labOtherMessage.text = @"书虫";
    
    NSString *fansCount = [NSString stringWithFormat:@"粉丝：%d",(arc4random() % 1000) + 1];
    NSString *followCount = [NSString stringWithFormat:@"关注：%d",(arc4random() % 1000) + 1];
    
    [self.btnFans setTitle:fansCount forState:UIControlStateNormal];
    [self.btnFollow setTitle:followCount forState:UIControlStateNormal];
    
    if (author.lv > 0)
    {
        [self.btnCircle setImage:[UIImage imageNamed:@"VIP_Valid"] forState:UIControlStateNormal];
    }
}

/**
 *  头像点击事件
 */
-(void)userIconTapAction:(UITapGestureRecognizer *)tap
{
    if (!self.info) return;
    
    self.isChangeIcon = YES;
    
    [self pushImagePickerController];
}

/**
 *  背景图
 */
-(void)backgrounImageTapAction:(UITapGestureRecognizer *)tap
{
    if (!self.info) return;
    
    self.isChangeIcon = NO;
    
    [self pushImagePickerController];
}

-(void)pushImagePickerController
{
    // 相册选取
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;//最小选取照片数
    imagePickerController.maximumNumberOfSelection = 1;//最大选取照片数
    imagePickerController.selectedAssetArray = [NSMutableArray arrayWithCapacity:0];//已经选择了的照片
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    kSelfWeak;
    [self startActivityWithText:@"提交修改"];
    for (JKAssets *asset in assets)
    {
        ALAssetsLibrary  *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                if (weakSelf.isChangeIcon) {
                    
                    [SingletonUser sharedSingletonUser].userInfo.userIconImage = image;
                }else{
                    [SingletonUser sharedSingletonUser].userInfo.backIconImage = image;
                }
                weakSelf.info = [SingletonUser sharedSingletonUser].userInfo;
                
                [weakSelf syncTaskOnMain:^{
                    [weakSelf stopActivityWithText:@"提交成功" state:ActivityHUDStateSuccess];
                } after:1];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    [imagePicker.navigationController popViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker.navigationController popViewControllerAnimated:YES];
}

/**
 *  开通会员
 */
- (IBAction)jumpToUserCircleAction:(UIButton *)sender
{
    PublicWebController *public = [[PublicWebController alloc] init];
    public.detailTitle = @"会员中心";
    public.detailURL = @"http://www.cnblogs.com/silence-wzx/";
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:public animated:YES];
}

/**
 *  认证按钮事件
 */
- (IBAction)btnSignMessageAction:(UIButton *)sender
{
    PublicWebController *public = [[PublicWebController alloc] init];
    public.detailTitle = @"认证资料";
    public.detailURL = @"";
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:public animated:YES];
}

/**
 *  顶部导航 返回、设置 按钮事件
 */
- (IBAction)barItemClickAction:(UIButton *)sender
{
    // 555 666
    BarItemPosition posttion = sender.tag == 555 ? BarItemPositionOfLeft : BarItemPositionOfRight;
    
    if ([self.delegate respondsToSelector:@selector(headerView:barItemClick:)])
    {
        [self.delegate headerView:self barItemClick:posttion];
    }
}

/**
 *  底部 关注、粉丝 按钮事件
 */
- (IBAction)bottomMenuClickAction:(UIButton *)sender
{
    // 556 667
    BarItemPosition posttion = sender.tag == 556 ? BarItemPositionOfLeft : BarItemPositionOfRight;
    
    if ([self.delegate respondsToSelector:@selector(headerView:bottomMenuClick:)])
    {
        [self.delegate headerView:self bottomMenuClick:posttion];
    }
}


@end
