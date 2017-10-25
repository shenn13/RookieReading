//
//  BookTextSectionOneCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextSectionOneCell.h"

@interface BookTextSectionOneCell ()

@property (weak, nonatomic) IBOutlet UILabel *labBookName;
@property (weak, nonatomic) IBOutlet UILabel *labAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labProduct;

@end

@implementation BookTextSectionOneCell

-(void)setTextBook:(TextBook *)textBook
{
    _textBook = textBook;
    
    self.labBookName.text = textBook.title;
    
    self.labAuthor.text = textBook.author;
    
    self.labProduct.text = textBook.shortIntro;
}

@end
