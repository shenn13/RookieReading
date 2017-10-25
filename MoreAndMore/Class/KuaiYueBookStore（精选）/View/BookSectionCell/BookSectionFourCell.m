//
//  BookSectionFourCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSectionFourCell.h"

@interface BookSectionFourCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UIButton *bookTag;
@property (weak, nonatomic) IBOutlet UILabel *bookProduct;


@end

@implementation BookSectionFourCell

+(BookSectionFourCell *)sectionFourCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    BookSectionFourCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"FOURTH_COLLECTION" forIndexPath:indexPath];
    
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
    
    self.bookName.text = topic.title;
    self.bookAuthor.text = topic.user.nickname;
    [self.bookTag setBackgroundColor:[UIColor colorWithHexString:topic.label_color]];
    [self.bookTag setTitleColor:[UIColor colorWithHexString:topic.label_text_color] forState:UIControlStateNormal];
    [self.bookTag setTitle:topic.label_text forState:UIControlStateNormal];
    self.bookProduct.text = topic.topic_description;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.pic] placeholderImage:DEFAULT_BG];
}

@end
