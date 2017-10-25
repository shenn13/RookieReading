//
//  ThemeHeaderCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ThemeHeaderCell.h"

#import "TextReviewModel.h"

#define THEME_HEADER    @"THEME_HEADER"

@implementation ThemeHeaderCell

+(ThemeHeaderCell *)themeHeaderCell:(UITableView *)tableiView
{
    ThemeHeaderCell *themeHeader = [tableiView dequeueReusableCellWithIdentifier:THEME_HEADER];
    if (!themeHeader) {
        themeHeader = [[NSBundle mainBundle] loadNibNamed:@"ThemeHeaderCell" owner:nil options:nil][0];
    }
    return themeHeader;
}

-(void)setListModel:(ThemeBookListModel *)listModel
{
    _listModel = listModel;
    
    [self.showIcon sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(listModel.author.avatar)] placeholderImage:DEFAULT_ICON];
    
    self.showName.text = listModel.author.nickname;
    
    self.showTime.text = [TextReviewModel zhuiShuTimeStrToDescription:listModel.created];
    
    self.showTitle.text = listModel.title;
    
    self.showDes.text = listModel.desc;
    
}

@end
