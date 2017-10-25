//
//  MyHeaderTitleView.m
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MyHeaderTitleView.h"

@implementation MyHeaderTitleView

-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    self.btnDelete.hidden = !isEdit;
}

- (IBAction)bookDeleteAction:(UIButton *)sender
{
    if (self.isEdit && [self.delegate respondsToSelector:@selector(MyHeaderRemoveBook:)])
    {
        [self.delegate MyHeaderRemoveBook:self];
    }
}

@end
