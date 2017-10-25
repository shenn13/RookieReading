//
//  TopicUserCenterCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "TopicUserCenterCell.h"

#define TOPIC_USERCENTER    @"TOPIC_USERCENTER"

@interface TopicUserCenterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labProduct;


@end

@implementation TopicUserCenterCell

-(void)awakeFromNib
{
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
    
}

+(TopicUserCenterCell *)topicUserCenter:(UITableView *)tableView
{
    TopicUserCenterCell *topic = [tableView dequeueReusableCellWithIdentifier:TOPIC_USERCENTER];
    if (!topic) {
        topic = [[NSBundle mainBundle] loadNibNamed:@"TopicUserCenterCell" owner:nil options:nil][0];
    }
    return topic;
}

-(void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    NSString *iamgeStr = topic.cover_image_url.length > 0 ? topic.cover_image_url : topic.pic;
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:iamgeStr] placeholderImage:DEFAULT_BG];
    
    self.labTitle.text = topic.title;
    self.labProduct.text = topic.topic_description;
}

@end
