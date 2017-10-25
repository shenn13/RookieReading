//
//  SDTimeLineImageCell.m
//  WCLDConsulting
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "SDTimeLineImageCell.h"

@implementation SDTimeLineImageCell

-(SDWeiXinPhotoContainerView *)photoViews
{
    if (!_photoViews) {
        _photoViews = [SDWeiXinPhotoContainerView new];
    }
    return _photoViews;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 按顺序添加子控件
        [self.contentView sd_addSubviews:@[self.topView,self.photoViews,self.descriptionView,self.bottomLine,self.rightView]];
        
        // 设置约束
        [self setupLayoutIfNeed];
    }
    return self;
}

-(void)setupLayoutIfNeed
{
    UIView *contentView = self.contentView;
    
    self.topView.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0)
    .rightEqualToView(contentView)
    .autoHeightRatio(0);
    
    self.photoViews.sd_layout
    .leftSpaceToView(contentView,MARGIN * 2 + TOP_ICON_WH)
    .topSpaceToView(self.topView,MARGIN);
    
    self.descriptionView.sd_layout
    .leftEqualToView(self.photoViews)
    .topSpaceToView(self.photoViews,MARGIN)
    .rightSpaceToView(contentView,MARGIN)
    .heightIs(20);
}

-(void)configModelWithModel:(SDTimeLineCellModel *)model
{
    // 图片区域
    CGFloat topMar = MARGIN;
    if (model.picNamesArray.count < 1)
    {
        topMar = 0;
    }
    self.photoViews.sd_layout.topSpaceToView(self.topView,topMar);
    
    self.photoViews.picPathStringsArray = model.picNamesArray;
    
}

@end
