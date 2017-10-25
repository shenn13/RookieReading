//
//  TopicUserCenterCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface TopicUserCenterCell : UITableViewCell

+(TopicUserCenterCell *)topicUserCenter:(UITableView *)tableView;

@property (nonatomic,strong)Topic *topic;

@end
