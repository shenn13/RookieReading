//
//  MoreTopicCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MoreTopicCell.h"

@interface MoreTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@property (weak, nonatomic) IBOutlet UILabel *showName;

@property (weak, nonatomic) IBOutlet UILabel *showAuthor;

@property (weak, nonatomic) IBOutlet UIButton *btnFollow;


@property (weak, nonatomic) IBOutlet UIImageView *imglike;
@property (weak, nonatomic) IBOutlet UILabel *showLikeCount;


@property (weak, nonatomic) IBOutlet UIImageView *imgCommentCount;
@property (weak, nonatomic) IBOutlet UILabel *showCommonCount;

@end

@implementation MoreTopicCell

-(void)awakeFromNib
{
    self.showImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImage.layer.borderWidth = 0.5f;
    self.showImage.layer.masksToBounds = YES;
    
    [self.btnFollow setBackgroundColor:[UIColor whiteColor]];
    self.btnFollow.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.btnFollow addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
}

+(MoreTopicCell *)moreTopicCell:(UITableView *)tableView
{
    MoreTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:@"MORE_TOPIC"];
    if (!topicCell) {
        topicCell = [[NSBundle mainBundle] loadNibNamed:@"MoreTopicCell" owner:nil options:nil][0];
    }
    
    return topicCell;
}

-(void)setTopic:(Topic *)topic
{
    _topic = topic;

    NSString *iamgeStr = topic.cover_image_url.length > 0 ? topic.cover_image_url : topic.pic;
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:iamgeStr] placeholderImage:DEFAULT_BG];
    
    self.showName.text = topic.title;
    self.showAuthor.text = topic.user.nickname;
    self.showLikeCount.text = [NSString stringWithFormat:@"%.2f万",topic.likes_count/10000.f];
    self.showCommonCount.text = [NSString stringWithFormat:@"%ld",topic.comments_count];

    // 是否已关注
    NSString *collect = topic.is_favourite ? @"btn_collect_yes" : @"btn_collect_not";
    
    [self.btnFollow setImage:[UIImage imageNamed:collect] forState:UIControlStateNormal];
}

- (void)collectAction:(UIButton *)btnCollect
{
    if ([self.delegate respondsToSelector:@selector(moreTopic:didClickCollect:)])
    {
        [self.delegate moreTopic:self didClickCollect:self.topic];
    }
}

@end
