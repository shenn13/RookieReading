//
//  CircleHeaderView.m
//  WCLDConsulting
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "CircleHeaderView.h"

#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"

#import "SDTimeLineCellModel.h"

const CGFloat contentLabelFontSize = 15;
// 根据具体font而定
CGFloat maxContentLabelHeight = 0;

@implementation CircleHeaderView
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    MLEmojiLabel *_contentLabel;
    UIButton *_moreButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        
        _iconView = [UIImageView new];
        _iconView.userInteractionEnabled = YES;
        _iconView.layer.masksToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconOrNameClickAction:)];
        iconTap.numberOfTapsRequired = 1;
        iconTap.numberOfTouchesRequired = 1;
        [_iconView addGestureRecognizer:iconTap];
        
        _nameLable = [UILabel new];
        _nameLable.userInteractionEnabled = YES;
        _nameLable.font = [UIFont systemFontOfSize:contentLabelFontSize + 1];
        _nameLable.textColor = [UIColor grayColor];
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconOrNameClickAction:)];
        nameTap.numberOfTapsRequired = 1;
        nameTap.numberOfTouchesRequired = 1;
        [_nameLable addGestureRecognizer:nameTap];
        
        _contentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:contentLabelFontSize]];
        [_contentLabel setHighlightedTextColor:[UIColor lightGrayColor]];
        [_contentLabel setLineSpacing:0];
        [_contentLabel setTextInsets:UIEdgeInsetsZero];
        [_contentLabel setDelegate:self];
        _contentLabel.isNeedAtAndPoundSign = YES;
        
        /*
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textContentClickAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_contentLabel addGestureRecognizer:tap];
         */
        
        if (maxContentLabelHeight == 0) {
            maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
        }
        
        _moreButton = [UIButton new];
        [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);

        NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton];
        
        [self sd_addSubviews:views];
        
        // 设置约束
        [self setupLayoutIfNeed];
    }
    return self;
}

-(void)setupLayoutIfNeed
{
    UIView *contentView = self;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(TOP_ICON_WH)
    .heightIs(TOP_ICON_WH);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // "更多"按钮的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(50);
}

-(void)setTopModel:(SDTimeLineCellModel *)topModel
{
    _topModel = topModel;
    
    // 头像
    if (topModel.showDel)
    {
        UIImage *defImage = [SingletonUser sharedSingletonUser].userInfo.userIconImage ? [SingletonUser sharedSingletonUser].userInfo.userIconImage : DEFAULT_ICON;
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:[SingletonUser sharedSingletonUser].userInfo.avatar] placeholderImage:defImage];
    }
    else
    {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:topModel.iconName] placeholderImage:DEFAULT_ICON];
    }
    
    
    // 昵称
    _nameLable.text = topModel.name;
    [_nameLable sizeToFit];
    
    // 文本内容区域
    [_contentLabel setText:topModel.msgContent];

    _contentLabel.sd_layout.topSpaceToView(_nameLable,10);
    
    // 展开和关闭按钮
    NSString *imageStr = topModel.isOpening ? @"up" : @"down";
    [_moreButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    
    UIView *bottomView;
    if (topModel.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(30);
        _moreButton.hidden = NO;
        if (topModel.isOpening) { // 如果需要展开
            [_contentLabel setMaxNumberOfLinesToShow:0];
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            [_contentLabel setMaxNumberOfLinesToShow:3];
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
        bottomView = _moreButton;
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
        bottomView = _contentLabel;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

// 超链接点击事件
#pragma mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    // MLEmojiLabelLinkTypePoundSign  英镑符号(股票)
    // MLEmojiLabelLinkTypeAt  @用户集
    // MLEmojiLabelLinkTypeURL  URL链接
    if (type == MLEmojiLabelLinkTypePhoneNumber)  // 电话
    {
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",link];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self addSubview:callWebview];
        return;
    }
    NSString *linkValue;
    if(type == MLEmojiLabelLinkTypeURL)
    {
        if (![link hasPrefix:@"www"] && ![link hasPrefix:@"http"])
        {
            link = [NSString stringWithFormat:@"https://www.%@",link];
        }
        linkValue = link;
    }
    else
    {
        linkValue = self.topModel.replyUserId;
    }

    if (self.headerContentLinkTypeBlock && linkValue.length > 0) {
        self.headerContentLinkTypeBlock(type,link,linkValue);
    }
}

- (void)mlEmojiLabelDidSelectNoLink:(MLEmojiLabel *)emojiLabel
{
    NSLog(@"点击文本内容：链接之外的区域");

    if (self.topModel.msgContent.length < 1) return;
    
    if (self.circleHeaderViewBlock) {
        self.circleHeaderViewBlock(CircleHeaderViewActionOfTextContent);
    }
}

#pragma mark 自定义链接区域(视频链接、分享链接)
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if (self.headerContentLinkTypeBlock && url.absoluteString.length > 0) {
        self.headerContentLinkTypeBlock(MLEmojiLabelLinkTypeURL,url.absoluteString,url.absoluteString);
    }
}

#pragma mark - 手势/事件响应

-(void)userIconOrNameClickAction:(UITapGestureRecognizer *)tap
{
    CircleHeaderViewActionType type = CircleHeaderViewActionOfName;
    if ([tap.view isKindOfClass:[_iconView class]])
    {
        type = CircleHeaderViewActionOfIcon;
    }
    if (self.circleHeaderViewBlock) {
        self.circleHeaderViewBlock(type);
    }
}

-(void)textContentClickAction:(UITapGestureRecognizer *)tap
{
    if (self.circleHeaderViewBlock) {
        self.circleHeaderViewBlock(CircleHeaderViewActionOfTextContent);
    }
}

-(void)moreButtonClicked
{
    if (self.openOrCloseTextContentBlock) {
        self.openOrCloseTextContentBlock();
    }
}

@end
