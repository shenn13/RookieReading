//
//  ReviewBookCell.m
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ReviewBookCell.h"

#import "TextReviewModel.h"

#define REVIEW_BOOK_IDEN    @"REVIEW_BOOK_IDEN"

@interface ReviewBookCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UILabel *labTime;

@end

@implementation ReviewBookCell

- (void)awakeFromNib
{
    self.showImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.showImage.layer.borderWidth = 1.f;
}

+(ReviewBookCell *)reviewCell:(UITableView *)tableView
{
    ReviewBookCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:REVIEW_BOOK_IDEN];
    if (!reviewCell) {
        reviewCell = [[NSBundle mainBundle] loadNibNamed:@"ReviewBookCell" owner:nil options:nil][0];
    }
    return reviewCell;
}

-(void)setReviewModel:(BookReviewModel *)reviewModel
{
    _reviewModel = reviewModel;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(reviewModel.book.cover)] placeholderImage:DEFAULT_BG];
    
    self.labName.text = [NSString stringWithFormat:@"%@『%@』",reviewModel.book.title,reviewModel.book.typeDesc];
    
    self.labTime.text = [TextReviewModel zhuiShuTimeStrToDescription:reviewModel.updated];
}

@end
