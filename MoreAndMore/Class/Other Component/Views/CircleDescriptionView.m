//
//  CircleDescriptionView.m
//  WCLDConsulting
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "CircleDescriptionView.h"

#import "UIView+SDAutoLayout.h"
#import "UIView+Block.h"

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@implementation CircleDescriptionView
{
    // 时间描述
    UILabel *_timeLabel;
    // 删除按钮
    UIButton *_btnDel;
    // 点赞按钮
    UIButton *_parise;
    // 回复按钮
    UIButton *_reply;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 时间
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        
        // 删除按钮
        _btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDel setTitle:@"删除" forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnDel.titleLabel.font = _timeLabel.font;
        [_btnDel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        // 点赞按钮
        _parise = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parise setTitle:@"" forState:UIControlStateNormal];
        [_parise addTarget:self action:@selector(pariseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_parise setImage:[UIImage imageNamed:@"comment_like2"] forState:UIControlStateNormal];
        _parise.titleLabel.font = _timeLabel.font;
        _parise.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_parise setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _parise.contentMode = UIViewContentModeRight;
        
        // 回复按钮
        _reply = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reply setTitle:@"回复" forState:UIControlStateNormal];
        _reply.titleLabel.font = _timeLabel.font;
        [_reply addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reply setImage:[UIImage imageNamed:@"comment_count"] forState:UIControlStateNormal];
        _reply.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_reply setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _reply.contentMode = UIViewContentModeRight;
        
        NSArray *views = @[_timeLabel,_btnDel,_parise,_reply];
        
        [self sd_addSubviews:views];
        
        // 设置约束
        [self setupLayoutIfNeed];
    }
    return self;
}

-(void)setupLayoutIfNeed
{
    CGFloat margin = 10;

     _timeLabel.sd_layout
     .leftSpaceToView(self,0)
     .topSpaceToView(self,margin/2)
     .heightIs(15);
     [_timeLabel setSingleLineAutoResizeWithMaxWidth:110];
     
     _btnDel.sd_layout
     .leftSpaceToView(_timeLabel,margin)
     .topEqualToView(_timeLabel)
     .widthIs(40)
     .heightIs(15);
    
    _reply.sd_layout
    .rightSpaceToView(self,margin)
    .topEqualToView(_timeLabel)
    .widthIs(60)
    .heightIs(15);
    
    _parise.sd_layout
    .rightSpaceToView(_reply,margin)
    .topEqualToView(_timeLabel)
    .widthIs(60)
    .heightIs(15);
}

-(void)setDescriptionModel:(SDTimeLineCellModel *)descriptionModel
{
    _descriptionModel = descriptionModel;
    
    _btnDel.hidden = !descriptionModel.showDel;
    
    /**
     *  是自己不需要显示点赞和评论按钮
     */
    _parise.hidden = descriptionModel.showDel;
    _reply.hidden = descriptionModel.showDel;
    
    /*
    if (!_reply.hidden && descriptionModel.appType == AppApiTypeOfZhuiShu)
    {
        _reply.hidden = YES;
    }
    */
    
    [_parise setTitle:descriptionModel.likesCount forState:UIControlStateNormal];
    [_parise sizeToFit];
    
    UIColor *pariseColor = descriptionModel.isLiked ? THEME_COLOR : [UIColor grayColor];
    NSString *imaStr = descriptionModel.isLiked ? @"comment_like2_sel" : @"comment_like2";
    [_parise setImage:[UIImage imageNamed:imaStr] forState:UIControlStateNormal];
    [_parise setTitleColor:pariseColor forState:UIControlStateNormal];
    
    // 时间显示
    _timeLabel.text = descriptionModel.timeDescription;
    [_timeLabel sizeToFit];
}

-(void)btnDeleteAction:(UIButton *)btnDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除此条评论？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.operationMenuBlock) {
                self.operationMenuBlock(OperationMenuOfDelete);
            }
        }
    }];
}

-(void)replyAction:(UIButton *)reply
{
    if (self.operationMenuBlock) {
        self.operationMenuBlock(OperationMenuOfComment);
    }
}

-(void)pariseAction:(UIButton *)parise
{
    if (self.operationMenuBlock) {
        self.operationMenuBlock(OperationMenuOfDianZan);
    }
}

@end
