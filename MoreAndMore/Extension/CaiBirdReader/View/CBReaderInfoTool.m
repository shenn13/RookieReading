//
//  CBReaderInfoTool.m
//  MoreAndMore
//
//  Created by apple on 2017/2/28.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBReaderInfoTool.h"

@interface CBReaderInfoTool ()

@property (nonatomic,strong)UILabel *labTitle;

@end

@implementation CBReaderInfoTool

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *labTitle = [[UILabel alloc] init];
        labTitle.font = [UIFont boldSystemFontOfSize:15.f];
        labTitle.textColor = [UIColor grayColor];
        [self addSubview:labTitle];
        self.labTitle = labTitle;
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

+(CGRect)infoToolRect
{
    CGFloat horMar = 20.f;
    CGFloat verMar = 30.f;
    CGFloat originY = [UIScreen mainScreen].bounds.size.height - verMar;
    return CGRectMake(horMar,originY, [UIScreen mainScreen].bounds.size.width - horMar * 2, verMar);
}

-(void)setChalpterTitle:(NSString *)chalpterTitle
{
    _chalpterTitle = chalpterTitle;
    
    self.labTitle.text = chalpterTitle;
}

@end
