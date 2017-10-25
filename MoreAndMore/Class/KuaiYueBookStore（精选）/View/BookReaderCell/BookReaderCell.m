//
//  BookReaderCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookReaderCell.h"

@implementation BookReaderCell

- (void)awakeFromNib {
    self.readerImage.layer.masksToBounds = YES;
}

+(BookReaderCell *)bookCell:(UITableView *)tableView
{
    BookReaderCell *bookReader = [tableView dequeueReusableCellWithIdentifier:@"IMAGE_READER"];
    if (!bookReader) {
        bookReader = [[NSBundle mainBundle] loadNibNamed:@"BookReaderCell" owner:nil options:nil][0];
        bookReader.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return bookReader;
}


@end
