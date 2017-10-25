//
//  ReaderMenuCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ReaderMenuCell.h"

@implementation ReaderMenuCell

+(ReaderMenuCell *)readerMenu:(UITableView *)tableView
{
    ReaderMenuCell *readerMenu = [tableView dequeueReusableCellWithIdentifier:@"READER_MENU"];
    if (!readerMenu) {
        readerMenu = [MAINBUNDLE loadNibNamed:@"ReaderMenuCell" owner:nil options:nil][0];
    }
    return readerMenu;
}

- (IBAction)shareClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shareMenuActionClick)])
    {
        [self.delegate shareMenuActionClick];
    }
}

- (IBAction)commentClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(commentMenuActionClick)])
    {
        [self.delegate commentMenuActionClick];
    }
}

@end
