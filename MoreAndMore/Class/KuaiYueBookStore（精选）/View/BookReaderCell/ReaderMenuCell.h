//
//  ReaderMenuCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderMenuCellDelegate <NSObject>

-(void)shareMenuActionClick;

-(void)commentMenuActionClick;

@end

@interface ReaderMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;

@property (nonatomic,weak)id<ReaderMenuCellDelegate> delegate;

+(ReaderMenuCell *)readerMenu:(UITableView *)tableView;

@end
