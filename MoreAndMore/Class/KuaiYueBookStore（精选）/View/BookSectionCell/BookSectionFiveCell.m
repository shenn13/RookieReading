//
//  BookSectionFiveCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSectionFiveCell.h"

@interface BookSectionFiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *labText;

@end

@implementation BookSectionFiveCell

+(BookSectionFiveCell *)sectionFiveCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    BookSectionFiveCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"FIFTH_COLLECTION" forIndexPath:indexPath];
    
    return cell;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

-(void)setBanner:(Banner *)banner
{
    _banner = banner;
    
    NSMutableString *urlStr = [banner.pic mutableCopy];
    if ([urlStr hasSuffix:@"750"])
    {
        NSRange range = [urlStr rangeOfString:@"750"];
        
        [urlStr replaceCharactersInRange:range withString:@"640"];
    }
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:DEFAULT_BG];
    
    self.labText.text = banner.target_title;
}

@end
