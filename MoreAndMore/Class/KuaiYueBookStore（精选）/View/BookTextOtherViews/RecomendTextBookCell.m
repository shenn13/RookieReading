//
//  RecomendTextBookCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "RecomendTextBookCell.h"

#define RECOMEND_TEXT   @"RECOMEND_TEXT"

@interface RecomendTextBookCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;

@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *labPraiseCount;
@property (weak, nonatomic) IBOutlet UILabel *labAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labDes;

@end

@implementation RecomendTextBookCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

+(RecomendTextBookCell *)recomendCell:(UITableView *)tableView
{
    RecomendTextBookCell *recommentCell = [tableView dequeueReusableCellWithIdentifier:RECOMEND_TEXT];
    if (!recommentCell) {
        recommentCell = [[NSBundle mainBundle] loadNibNamed:@"RecomendTextBookCell" owner:nil options:nil][0];
    }
    return recommentCell;
}

-(void)setRecommentBook:(RecommendBookModel *)recommentBook
{
    _recommentBook = recommentBook;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:ZHUISHU_IMG(recommentBook.cover)] placeholderImage:DEFAULT_BG];
    
    self.bookName.text = recommentBook.title;
    
    self.labAuthor.text = recommentBook.author;
    
    self.labDes.text = recommentBook.desc;
    
    self.labPraiseCount.text = [NSString stringWithFormat:@"共 %ld 本书 | %ld 人已收藏",recommentBook.bookCount,recommentBook.collectorCount];
}

@end
