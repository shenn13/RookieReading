//
//  MyTextBookCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MyBookCellTwo.h"

@interface MyBookCellTwo ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labAuthor;
@property (weak, nonatomic) IBOutlet UIView *EditView;

@property (weak, nonatomic) IBOutlet UIButton *btnChoose;

@property (weak, nonatomic) IBOutlet UIImageView *showTagImage;


@end

@implementation MyBookCellTwo

-(void)awakeFromNib
{
    self.EditView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.btnChoose.layer.borderWidth = 2.f;
    self.btnChoose.layer.borderColor = THEME_COLOR.CGColor;
    
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

-(void)setReaderModel:(MyReaderBookModel *)readerModel
{
    _readerModel = readerModel;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:readerModel.showUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.labTitle.text = readerModel.bookName;
    self.labAuthor.text = readerModel.author;
    
    self.EditView.hidden = !readerModel.isEdit;
    
    self.btnChoose.selected = readerModel.isChoose;
    
    NSString *tagImage = readerModel.bookType == 0 ? @"book_tag_image" : @"book_tag_text";
    [self.showTagImage setImage:[UIImage imageNamed:tagImage]];
}

@end
