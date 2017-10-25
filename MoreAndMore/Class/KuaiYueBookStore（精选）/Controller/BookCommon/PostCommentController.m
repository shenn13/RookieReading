//
//  PostCommentController.m
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "PostCommentController.h"

@interface PostCommentController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@end

@implementation PostCommentController

+(PostCommentController *)postCommentController:(NSString *)placeHolder isReply:(BOOL)isReply appType:(AppApiType)type
{
    PostCommentController *postComment = BoardVCWithID(@"JingXuan", @"POST_COMMENT");
    postComment.isReply = isReply;
    postComment.placeHolder = placeHolder.length > 0 ? placeHolder : @"请输入评论内容";
    postComment.appType = type;
    return postComment;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布评论";
    
    self.textView.text = self.placeHolder;
    self.textView.textColor = [UIColor grayColor];
    
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = LINE_COLOR.CGColor;
    self.textView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.textView.contentSize = CGSizeMake(SCREEN_WIDTH - 40 - 16, CGFLOAT_MAX);
}


- (IBAction)btnPostCommentAction:(UIButton *)sender
{
    LOGINNEED_ACTION
    
    if (self.textView.text.length < 1 || [self.textView.text isEqualToString:self.placeHolder])
    {
        [self showText:@"请输入评论内容!" inView:self.view];
        return;
    }
    
    if (self.appType == AppApiTypeOfKuaiKan && [self.delegate respondsToSelector:@selector(kuaiKanPostComment:)])
    {
        [self startActivityWithText:@"提交中..."];
        NSString *content = self.textView.text;
        if (self.isReply) {
            
            content = [NSString stringWithFormat:@"%@%@",self.placeHolder,self.textView.text];
        }
        
        BookImageComent *newComment = [BookImageComent commentWithContent:content isReply:self.isReply replyComment:self.kuaiKanComment];
        
        kSelfWeak;
        [self asyncTask:^{
            [weakSelf.delegate kuaiKanPostComment:newComment];
            [weakSelf syncTaskOnMain:^{
                [weakSelf stopActivityWithText:@"发布成功!" state:ActivityHUDStateSuccess];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } after:1];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.text = @"";
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeHolder] && textView.textColor != [UIColor grayColor])
    {
        textView.textColor = [UIColor grayColor];
    }
    else
    {
        if (textView.textColor != [UIColor whiteColor])
        {
            textView.textColor = [UIColor whiteColor];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        textView.textColor = [UIColor grayColor];
        textView.text = self.placeHolder;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
