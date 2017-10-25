//
//  BookReaderCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookReaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *readerImage;

+(BookReaderCell *)bookCell:(UITableView *)tableView;

@end
