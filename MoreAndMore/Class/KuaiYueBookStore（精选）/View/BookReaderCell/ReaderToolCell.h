//
//  ReaderToolCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BookComicDetail.h"

@interface ReaderToolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *lastComic;
@property (weak, nonatomic) IBOutlet UIButton *nextComic;

@property (nonatomic,copy)NSString *lastComicId;

@property (nonatomic,copy)NSString *nextComicId;

+(ReaderToolCell *)readerTool:(UITableView *)tableView;

+(CGFloat)toolHeight;

@property(nonatomic,copy)void(^changeComicBlock)(NSString *comic);

@end
