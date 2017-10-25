//
//  BookTextSectionTwoCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextSectionTwoCell.h"

@interface BookTextSectionTwoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *labBookName;

@end

@implementation BookTextSectionTwoCell

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

    NSString *imagStr = ZHUISHU_IMG(textBook.cover);
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:imagStr] placeholderImage:DEFAULT_BG];
    
    self.labBookName.text = textBook.title;
}

@end
