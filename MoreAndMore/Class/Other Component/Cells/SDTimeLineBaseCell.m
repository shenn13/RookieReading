//
//  SDTimeLineBaseCell.m
//  WCLDConsulting
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "SDTimeLineBaseCell.h"

#import "SDTimeLineImageCell.h"

@implementation SDTimeLineBaseCell

-(CircleHeaderView *)topView
{
    if (!_topView) {
        __weak typeof(self) weakSelf = self;
        // 顶部区域
        _topView = [CircleHeaderView new];
        _topView.circleHeaderViewBlock = ^(CircleHeaderViewActionType type){
            if ([weakSelf.delegate respondsToSelector:@selector(didClickTopHeaderViewInCell:circleHeaderViewAction:)])
            {
                [weakSelf.delegate didClickTopHeaderViewInCell:weakSelf circleHeaderViewAction:type];
            }
        };
        
        _topView.headerContentLinkTypeBlock = ^(MLEmojiLabelLinkType type,NSString *linkText,NSString *linkValue){
            if ([weakSelf.delegate respondsToSelector:@selector(didClickLinkActionInCell:type:link:linkValue:)])
            {
                [weakSelf.delegate didClickLinkActionInCell:weakSelf type:type link:linkText linkValue:linkValue];
            }
        };
        _topView.openOrCloseTextContentBlock = ^(void){
            if ([weakSelf.delegate respondsToSelector:@selector(didClickMoreBtnInCell:)])
            {
                [weakSelf.delegate didClickMoreBtnInCell:weakSelf];
            }
        };
    }
    return _topView;
}

-(CircleDescriptionView *)descriptionView
{
    if (!_descriptionView) {
        __weak typeof(self) weakSelf = self;
        _descriptionView = [CircleDescriptionView new];
        // 描述区域
        _descriptionView  = [[CircleDescriptionView alloc] init];
        _descriptionView.operationMenuBlock = ^(OperationMenu type){
            if ([weakSelf.delegate respondsToSelector:@selector(didClickDescriptionMenuInCell:opeartionMenu:)])
            {
                [weakSelf.delegate didClickDescriptionMenuInCell:weakSelf opeartionMenu:type];
            }
        };
    }
    return _descriptionView;
}

-(UIImageView *)bottomLine
{
    if (!_bottomLine) {
        // 底部横线
        _bottomLine = [[UIImageView alloc] init];
        _bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomLine;
}

-(UIImageView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIImageView alloc] init];
        _rightView.backgroundColor = [UIColor clearColor];
        [_rightView setImage:[UIImage imageNamed:@"book_tag_jingxuan"]];
    }
    return _rightView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomLine.sd_layout
    .leftEqualToView(self.contentView)
    .heightIs(0.5)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    _rightView.sd_layout
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .widthIs(25)
    .heightIs(25);
}


+(SDTimeLineBaseCell *)SDTimeLineCell:(UITableView *)tableView model:(SDTimeLineCellModel *)model
{
    NSString *identifier;
    
    if (model.modelType == TimeLineModelTypeOfBookShare){
        // 分享类型
        identifier = kSDTIMELINE_SHARE;
    }else{
        // 默认类型(图文)
        identifier = kSDTIMELINE_IMAGE;
    }

    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

-(void)setModel:(SDTimeLineCellModel *)model
{
    _model = model;
    
    // 精选图标区域
    self.rightView.hidden = [model.state isEqualToString:@"distillate"] ? NO : YES;

    // 顶部区域
    self.topView.topModel = self.model;
    
    // 扩展区域
    [self configModelWithModel:model];
    
    self.descriptionView.descriptionModel = model;
    
    // 描述信息区域
    [self setupAutoHeightWithBottomView:self.descriptionView bottomMargin:15];
}

-(void)configModelWithModel:(SDTimeLineCellModel *)model
{
    
}

@end
