//
//  MoreTopicCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Topic.h"

@class MoreTopicCell;
@protocol MoreTopicCellDelegate <NSObject>

-(void)moreTopic:(MoreTopicCell *)moreCell didClickCollect:(Topic *)topic;

@end

@interface MoreTopicCell : UITableViewCell

+(MoreTopicCell *)moreTopicCell:(UITableView *)tableView;

@property (nonatomic,strong)Topic *topic;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,weak)id<MoreTopicCellDelegate> delegate;

@end
