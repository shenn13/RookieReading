//
//  BookTextSectionThreeCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextSectionThreeCell.h"

@interface BookTextSectionThreeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *labProduct;
@property (weak, nonatomic) IBOutlet UILabel *labBookName;
@property (weak, nonatomic) IBOutlet UILabel *labAuthor;


@end

@implementation BookTextSectionThreeCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

-(void)setTextBook:(TextBook *)textBook
{
    _textBook = textBook;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(textBook.cover)] placeholderImage:DEFAULT_BG];
    
    self.labBookName.text = textBook.title;
    self.labAuthor.text = textBook.author;
    self.labProduct.text = textBook.shortIntro;
}

@end
