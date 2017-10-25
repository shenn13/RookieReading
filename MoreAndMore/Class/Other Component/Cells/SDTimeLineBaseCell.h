//
//  SDTimeLineBaseCell.h
//  WCLDConsulting
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleHeaderView.h"
#import "CircleDescriptionView.h"

#import "SDTimeLineCellModel.h"

#import "UIView+SDAutoLayout.h"

#define MARGIN  10
#define kSDTIMELINE_BASE    @"SDTIMELINE_BASE"
#define kSDTIMELINE_IMAGE   @"SDTIMELINE_IMAGE"
#define kSDTIMELINE_SHARE   @"kSDTIMELINE_SHARE"
#define kSDTIMELINE_VIDEO  @"kSDTIMELINE_VIDEO"

@class SDTimeLineBaseCell;
@protocol SDTimeLineBaseCellDelegate <NSObject>

// 朋友圈用户说说头像、昵称、文本内容
- (void)didClickTopHeaderViewInCell:(SDTimeLineBaseCell *)cell circleHeaderViewAction:(CircleHeaderViewActionType)type;

/**
 *  底部工具栏点击事件
 */
-(void)didClickDescriptionMenuInCell:(SDTimeLineBaseCell *)cell opeartionMenu:(OperationMenu)menu;

/**
 *  超链接
 */
-(void)didClickLinkActionInCell:(SDTimeLineBaseCell *)cell type:(MLEmojiLabelLinkType)type link:(NSString *)link linkValue:(NSString *)linkValue;

/**
 *  查看更多
 */
-(void)didClickMoreBtnInCell:(SDTimeLineBaseCell *)cell;

@end

@interface SDTimeLineBaseCell : UITableViewCell

// UI相关
@property (nonatomic,strong)CircleHeaderView *topView;

@property (nonatomic,strong)CircleDescriptionView *descriptionView;

@property (nonatomic,strong)UIImageView *bottomLine;
// 精选图标
@property (nonatomic,strong)UIImageView *rightView;

@property (nonatomic,strong) NSIndexPath *indexPath;

// 数据相关
@property (nonatomic, strong) SDTimeLineCellModel *model;


@property (nonatomic, weak) id<SDTimeLineBaseCellDelegate> delegate;

+(SDTimeLineBaseCell *)SDTimeLineCell:(UITableView *)tableView model:(SDTimeLineCellModel *)model;

-(void)configModelWithModel:(SDTimeLineCellModel *)model;

@end
