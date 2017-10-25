//
//  BookTypeCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/15.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTypeCell.h"

@implementation BookTypeCell

- (void)awakeFromNib {
    
    self.showImage.layer.masksToBounds = YES;
    self.showImage.layer.cornerRadius = VIEW_WIDTH(self.showImage)/2;
    
    self.showImage.layer.borderColor = BORDER_COLOR.CGColor;
    self.showImage.layer.borderWidth = 0.5f;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

@end
