//
//  ContentHeaderView.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ContentHeaderView.h"

@implementation ContentHeaderView

- (IBAction)MoreAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectMoreAction:)])
    {
        [self.delegate didSelectMoreAction:self];
    }
}

@end
