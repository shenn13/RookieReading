//
//  BookComicCell.m
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookComicCell.h"

@interface BookComicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDate;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UIImageView *commonLike;

@end

@implementation BookComicCell

-(void)awakeFromNib
{
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
}

-(void)setComic:(BookComic *)comic
{
    _comic = comic;
    
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:comic.cover_image_url] placeholderImage:DEFAULT_BG];
    
    self.showTitle.text = comic.title;
    
    self.showDate.text = [NSString timeIntervalToTimeDescription:comic.updated_at * 1000 format:@"MM-dd HH:mm"];
    
    self.showCount.text = [self commentCountToDescription:comic.comments_count];
}

-(NSString *)commentCountToDescription:(NSInteger)count
{
    NSString *myCount = [NSString stringWithFormat:@"%ld",count];
    if (count/1000000000.f >= 1) {
        myCount = [NSString stringWithFormat:@"%.2lf亿",count/1000000000.f];
    }
    else if (count/100000000.f >= 1) {
        myCount = [NSString stringWithFormat:@"%.2lf千万",count/100000000.f];
    }
    else if (count/10000.f >= 1) {
        myCount = [NSString stringWithFormat:@"%.2lf万",count/10000.f];
    }
    return myCount;
}

@end
