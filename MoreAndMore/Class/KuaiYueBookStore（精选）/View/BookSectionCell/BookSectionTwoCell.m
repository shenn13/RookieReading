//
//  BookSectionTwoCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSectionTwoCell.h"

@interface BookSectionTwoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *labNumber;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labAuthor;

@end

@implementation BookSectionTwoCell

+(BookSectionTwoCell *)sectionTwoCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    BookSectionTwoCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"SECOND_COLLECTION" forIndexPath:indexPath];
    cell.labNumber.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    return cell;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

-(void)setTopic:(Topic *)topic
{
    _topic = topic;

    self.labTitle.text = topic.title;
    
    self.labAuthor.text = topic.user.nickname;
    
    if (topic.cover_image_url.length > 0) {
        [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.cover_image_url] placeholderImage:DEFAULT_BG];
        return;
    }
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.pic] placeholderImage:DEFAULT_BG];
}

@end
