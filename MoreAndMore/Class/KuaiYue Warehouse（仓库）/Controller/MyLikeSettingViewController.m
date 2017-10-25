//
//  MyLikeSettingViewController.m
//  MoreAndMore
//
//  Created by apple on 16/10/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MyLikeSettingViewController.h"

@interface MyLikeSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

// 男生

@property (weak, nonatomic) IBOutlet UIView *viewMale;
@property (weak, nonatomic) IBOutlet UIImageView *imaMale;
@property (weak, nonatomic) IBOutlet UILabel *labMale;
// 女生
@property (weak, nonatomic) IBOutlet UIView *viewFemale;
@property (weak, nonatomic) IBOutlet UIImageView *imaFemale;
@property (weak, nonatomic) IBOutlet UILabel *labFemale;
// 图书
@property (weak, nonatomic) IBOutlet UIView *viewCortoon;
@property (weak, nonatomic) IBOutlet UIImageView *imaCartoon;
@property (weak, nonatomic) IBOutlet UILabel *labCartoon;

@end

@implementation MyLikeSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的阅读偏好";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"preference_bg"]];
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"cell_checkmark_white"] selArr:nil];
    
    self.likeType = [SingletonUser sharedSingletonUser].likeType;
}

-(void)setLikeType:(MyLikeType)likeType
{
    _likeType = likeType;
    
    // 图片选择状态
    NSString *maleImage = @"prefer_male_uncheck";
    NSString *femaleImage = @"prefer_female_uncheck";
    NSString *cortoonImage = @"prefer_publish_uncheck";
    
    // 背景色
    UIColor *maleColor = [UIColor colorWithHexString:@"0xD1DED9"];
    UIColor *femaleColor = [UIColor colorWithHexString:@"0xD1DED9"];
    UIColor *cortoonColor = [UIColor colorWithHexString:@"0xD1DED9"];
    
    if (likeType == MyLikeTypeOfMale) {
        maleImage = @"prefer_male_check";
        maleColor = [UIColor colorWithHexString:@"0xC0DACF"];
    }else if (likeType == MyLikeTypeOfFemale){
        femaleImage = @"prefer_female_check";
        femaleColor = [UIColor colorWithHexString:@"0xC0DACF"];
    }else if (likeType == MyLikeTypeOfCortoon){
        cortoonImage = @"prefer_publish_check";
        cortoonColor = [UIColor colorWithHexString:@"0xC0DACF"];
    }
    
    // #D1DED9  未选中
    // #C0DACF  选中
    self.viewMale.backgroundColor = maleColor;
    self.viewFemale.backgroundColor = femaleColor;
    self.viewCortoon.backgroundColor = cortoonColor;
    
    self.imaMale.image = [UIImage imageNamed:maleImage];
    self.imaFemale.image = [UIImage imageNamed:femaleImage];
    self.imaCartoon.image = [UIImage imageNamed:cortoonImage];
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    LOGINNEED_ACTION
    
    if ([self.delegate respondsToSelector:@selector(myLikeSettingChangeAction:)] && [SingletonUser sharedSingletonUser].likeType != self.likeType)
    {
        [self.delegate myLikeSettingChangeAction:self.likeType];
        
        [SingletonUser sharedSingletonUser].likeType = self.likeType;
        [[SingletonUser sharedSingletonUser] saveToFile];
    }
    
    [self dismissOrPopBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > 0)
    {
        self.likeType = indexPath.section - 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section <= 1) {
        return 0.1f;
    }
    return 10.f;
}

@end
