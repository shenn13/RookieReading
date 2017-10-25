//
//  BookTextMoreCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextMoreCell.h"

#define BOOKTEXT_MORE   @"BOOKTEXT_MORE"

@interface BookTextMoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *bookName;

@property (weak, nonatomic) IBOutlet UILabel *bookProduct;

@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;

@property (weak, nonatomic) IBOutlet UILabel *bookPriseCount;

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@end

@implementation BookTextMoreCell

-(void)awakeFromNib
{
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

+(BookTextMoreCell *)textMoreCell:(UITableView *)tableView
{
    BookTextMoreCell *textMore = [tableView dequeueReusableCellWithIdentifier:BOOKTEXT_MORE];
    if (!textMore) {
        textMore = [[NSBundle mainBundle] loadNibNamed:@"BookTextMoreCell" owner:nil options:nil][0];
    }
    return textMore;
}

-(void)setTextBook:(TextBook *)textBook
{
    _textBook = textBook;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(textBook.cover)] placeholderImage:DEFAULT_BG];
    
    self.bookName.text = textBook.title;
    
    self.bookAuthor.text = textBook.author;
    
    self.bookProduct.text = textBook.shortIntro;
    
    self.bookPriseCount.text = [NSString stringWithFormat:@"%ld人在追",textBook.latelyFollower];
    
    self.btnCollect.selected = textBook.isCollect;
}

-(void)setRecommentBook:(RecommendBookModel *)recommentBook
{
    _recommentBook = recommentBook;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(recommentBook.cover)] placeholderImage:DEFAULT_BG];
    
    self.bookName.text = recommentBook.title;
    
    self.bookAuthor.text = recommentBook.author;
    
    self.bookProduct.text = recommentBook.desc;
    
    self.bookPriseCount.text = [NSString stringWithFormat:@"%ld人已收藏",recommentBook.collectorCount];
    
    self.btnCollect.hidden = YES;
}

- (IBAction)bookTextColectAction:(UIButton *)sender
{
    LOGINNEED_ACTION;
    
    if ([self.delegate respondsToSelector:@selector(moreTextBook:didClickCollect:)])
    {
        [self.delegate moreTextBook:self didClickCollect:self.textBook];
    }
}

@end
