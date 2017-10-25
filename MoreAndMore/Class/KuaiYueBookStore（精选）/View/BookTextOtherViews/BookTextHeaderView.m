//
//  BookTextHeaderView.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextHeaderView.h"

@interface BookTextHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *bookName;

@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookProduct;
/**
 *  底部菜单区域
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *btnMenuList;
@property (weak, nonatomic) IBOutlet UIButton *btnReader;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;


@end

@implementation BookTextHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.showImage.layer.masksToBounds = YES;
    self.showImage.layer.borderColor = LINE_COLOR.CGColor;
    self.showImage.layer.borderWidth = 0.5f;
}

+(BookTextHeaderView *)bookTextHeader
{
    BookTextHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"BookTextHeaderView" owner:nil options:nil][0];
    
    header.backgroundColor = [UIColor clearColor];
    
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, TEXT_HEADERHEI);
    
    return header;
}

-(void)setDetail:(TextBookDetail *)detail
{
    _detail = detail;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(detail.cover)] placeholderImage:DEFAULT_BG];
    
    self.bookName.text = detail.title;
    
    self.bookAuthor.text = [NSString stringWithFormat:@"%@ | %@ | %.2lf万字",detail.author,detail.cat,detail.wordCount/10000.f];
    
    self.bookProduct.text = detail.longIntro;
}

-(void)setTextBook:(TextBook *)textBook
{
    _textBook = textBook;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(textBook.cover)] placeholderImage:DEFAULT_BG];
    
    self.bookName.text = textBook.title;
    
    self.bookAuthor.text = textBook.author;
    
    self.bookProduct.text = textBook.shortIntro;
}

- (IBAction)menuClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickMenu)])
    {
        [self.delegate headerViewDidClickMenu];
    }
}

- (IBAction)readerClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickReader)])
    {
        [self.delegate headerViewDidClickReader];
    }
}

- (IBAction)shareClickAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickShare)])
    {
        [self.delegate headerViewDidClickShare];
    }
}

@end
