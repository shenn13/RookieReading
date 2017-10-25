//
//  ProductCollectionCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ProductCollectionCell.h"

@implementation ProductCollectionCell

-(void)awakeFromNib
{
    self.userIcon.contentMode = UIViewContentModeScaleAspectFit;
}

+(CGFloat)productHeight
{
    return 120.f;
}


- (IBAction)userClickAction:(UIButton *)sender
{
    [self showText:@"进入个人中心" inView:WINDOW];
}

@end
