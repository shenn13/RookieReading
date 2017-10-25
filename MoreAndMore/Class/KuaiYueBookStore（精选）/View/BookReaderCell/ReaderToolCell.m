//
//  ReaderToolCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ReaderToolCell.h"

@implementation ReaderToolCell

+(ReaderToolCell *)readerTool:(UITableView *)tableView
{
    ReaderToolCell *toolCell = [tableView dequeueReusableCellWithIdentifier:@"READER_TOOL"];
    if (!toolCell) {
        toolCell = [[NSBundle mainBundle] loadNibNamed:@"ReaderToolCell" owner:nil options:nil][0];
        toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        toolCell.lastComic.layer.borderColor = LINE_COLOR.CGColor;
        toolCell.lastComic.layer.borderWidth = 1.f;
        toolCell.nextComic.layer.borderColor = LINE_COLOR.CGColor;
        toolCell.nextComic.layer.borderWidth = 1.f;
    }
    return toolCell;
}

-(void)setLastComicId:(NSString *)lastComicId
{
    _lastComicId = lastComicId;
    
    if (lastComicId == nil || lastComicId.length < 1)
    {
        self.lastComic.enabled = NO;
    }
    else
    {
        self.lastComic.enabled = YES;
    }
}

-(void)setNextComicId:(NSString *)nextComicId
{
    _nextComicId = nextComicId;
    
    if (nextComicId == nil || nextComicId.length < 1)
    {
        self.nextComic.enabled = NO;
    }
    else
    {
        self.nextComic.enabled = YES;
    }
}

+(CGFloat)toolHeight
{
    return 80.f;
}

- (IBAction)changeComicAction:(UIButton *)sender
{
    if (sender == self.lastComic)  // 上一章
    {
        if (self.lastComicId.length > 0 && self.changeComicBlock)
        {
            self.changeComicBlock(self.lastComicId);
        }
    }
    else  // 下一章
    {
        if (self.nextComicId.length > 0 && self.changeComicBlock)
        {
            self.changeComicBlock(self.nextComicId);
        }
    }
}



@end
