//
//  FeedBackViewController.m
//  MoreAndMore
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "FeedBackViewController.h"

#define PLACE_HOLDER    @"请写下您宝贵的意见和建议~"

@interface FeedBackViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *txfContact;

@end

@implementation FeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.title = @"意见反馈";
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:NO spacer:10 norArr:@[@"提交"] selArr:nil];
    
    self.textView.text = PLACE_HOLDER;
    self.textView.textColor = [UIColor lightGrayColor];
    
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    if (self.textView.text.length < 1) {
        [self showText:@"反馈意见不能为空！" inView:self.view];
        return;
    }
    else if (self.txfContact.text.length < 1) {
        [self showText:@"请输入您的联系方式！" inView:self.view];
        return;
    }
    
    [self startActivityWithText:REQUESTTIPING];
    
    kSelfWeak;
    [self syncTaskOnMain:^{
        [weakSelf stopActivityWithText:@"您的反馈已成功\n处理结果将会以您填写的联系方式反馈！" state:ActivityHUDStateSuccess];
        [weakSelf.navigationController popViewControllerAnimated:YES];
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.text = @"";
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACE_HOLDER] && textView.textColor != [UIColor lightGrayColor])
    {
        textView.textColor = [UIColor lightGrayColor];
    }
    else
    {
        if (textView.textColor != [UIColor blackColor])
        {
            textView.textColor = [UIColor blackColor];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = PLACE_HOLDER;
    }
}
@end
