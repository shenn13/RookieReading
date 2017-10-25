//
//  LibraryBookTextHeaderView.m
//  MoreAndMore
//
//  Created by apple on 16/10/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "LibraryBookTextHeaderView.h"

@implementation LibraryBookTextHeaderView

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)headerLikeSettingAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickHeaderLikeSetingAction)])
    {
        [self.delegate didClickHeaderLikeSetingAction];
    }
}


@end
