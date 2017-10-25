//
//  BookSectionOneCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSectionOneCell.h"

@interface BookSectionOneCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;

@end

@implementation BookSectionOneCell

+(BookSectionOneCell *)sectionOneCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    BookSectionOneCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"FIRST_COLLECTION" forIndexPath:indexPath];
    
    return cell;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    // 初始化遮罩
    // [self.labTitle grandientLayerWithDirection:ZXLayerDirectionOfTopToBottom color:[UIColor clearColor] toColor:[UIColor blackColor]];
    
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

-(void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    self.labTitle.text = topic.title;
    
    if (topic.cover_image_url.length > 0) {
        [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.cover_image_url] placeholderImage:DEFAULT_BG];
        return;
    }

    [self.showImage sd_setImageWithURL:[NSURL URLWithString:topic.pic] placeholderImage:DEFAULT_BG];
}

-(void)setTextBook:(TextBook *)textBook
{
    _textBook = textBook;
    
    NSString *imgStr = ZHUISHU_IMG(textBook.cover);
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:DEFAULT_BG];

    self.labTitle.text = textBook.title;
    self.labDetail.text = textBook.author;
}

@end
