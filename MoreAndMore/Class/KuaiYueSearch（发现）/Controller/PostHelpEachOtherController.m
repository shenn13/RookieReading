//
//  PostHelpEachOtherController.m
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "PostHelpEachOtherController.h"

@interface PostHelpEachOtherController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *reviewContent;

@end

@implementation PostHelpEachOtherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.reviewContent.placeholder = self.placeHolder;
    
    self.navigationItem.title = @"发布书荒求助";
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"cell_checkmark_white"] selArr:nil];
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    LOGINNEED_ACTION
    
    if (self.reviewContent.text.length < 1)
    {
        [self showText:@"请输入书荒内容！" inView:self.view];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(zhuiShuPostComment:)])
    {
        [self startActivityWithText:@"提交中..."];
        
        TextReviewModel *reviewModel = [TextReviewModel commentWithContent:self.reviewContent.text isReply:self.isReply replyComment:self.reviewModel];
        
        kSelfWeak;
        [self asyncTask:^{
            [weakSelf.delegate zhuiShuPostComment:reviewModel];
            [weakSelf syncTaskOnMain:^{
                [weakSelf stopActivityWithText:@"发布成功!" state:ActivityHUDStateSuccess];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } after:1];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
