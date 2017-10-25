//
//  ThemeBookCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ThemeBookCell.h"

#define THEME_BOOK  @"THEME_BOOK"

@interface ThemeBookCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showMessage;
@property (weak, nonatomic) IBOutlet UILabel *showComment;

@end

@implementation ThemeBookCell

- (void)awakeFromNib
{
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

+(ThemeBookCell *)themeBookCell:(UITableView *)tableView
{
    ThemeBookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:THEME_BOOK];
    if (!bookCell) {
        bookCell = [[NSBundle mainBundle] loadNibNamed:@"ThemeBookCell" owner:nil options:nil][0];
    }
    return bookCell;
}

-(void)setBookModel:(ThemeBookModel *)bookModel
{
    _bookModel = bookModel;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(bookModel.book.cover)] placeholderImage:DEFAULT_BG];
    
    self.showName.text = bookModel.book.title;
    
    self.showMessage.text = [NSString stringWithFormat:@"%@ | %@ | %ld人在追",bookModel.book.author,bookModel.book.cat,bookModel.book.latelyFollower];
    
    self.showComment.text = bookModel.comment.length > 0 ? bookModel.comment : @"暂无评论!";
}

@end
