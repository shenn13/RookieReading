//
//  AppConfigStyleCell.m
//  topLicaiPro
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "AppConfigStyleCell.h"

#define CONFIG_IDENTIFIER  @"CONFIG_IDENTIFIER"

@interface AppConfigStyleCell ()

@property (nonatomic,weak)UIView *bottomLine;

@end

@implementation AppConfigStyleCell

+(AppConfigStyleCell *)configCell:(UITableView *)tableView
{
    AppConfigStyleCell *configCell = [tableView dequeueReusableCellWithIdentifier:CONFIG_IDENTIFIER];
    if (!configCell) {
        configCell = [[AppConfigStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONFIG_IDENTIFIER];
        configCell.tintColor = [UIColor lightGrayColor];
        configCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return configCell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // 标题文本
        UILabel *labTitle = [[UILabel alloc] init];
        labTitle.font =[UIFont systemFontOfSize:15];
        // 底部横线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        bottomLine.alpha = 0.25;

        [self.contentView addSubview:labTitle];
        [self addSubview:bottomLine];
        self.labTitle = labTitle;
        self.bottomLine = bottomLine;
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.centerY.mas_offset(0);
        }];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return self;
}

+(CGFloat)rowHeight
{
    return 50.f;
}

@end
