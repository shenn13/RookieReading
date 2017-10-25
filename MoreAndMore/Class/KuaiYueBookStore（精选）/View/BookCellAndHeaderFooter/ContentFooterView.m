//
//  ContentFooterView.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ContentFooterView.h"

@interface ContentFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@end

@implementation ContentFooterView

-(void)awakeFromNib
{
    self.btnPost.backgroundColor = THEME_COLOR;
}

- (IBAction)PostAction:(UIButton *)sender
{
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation.tabBarController setSelectedIndex:2];
}

@end
