//
//  BookSectionThreeCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSectionThreeCell.h"

@interface BookSectionThreeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@end

@implementation BookSectionThreeCell

+(BookSectionThreeCell *)sectionThreeCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    BookSectionThreeCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"THIRD_COLLECTION" forIndexPath:indexPath];
    
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
    
    if (topic.cover_image_url.length > 0) {
        [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.cover_image_url] placeholderImage:DEFAULT_BG];
        return;
    }
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.pic] placeholderImage:DEFAULT_BG];
}

@end
