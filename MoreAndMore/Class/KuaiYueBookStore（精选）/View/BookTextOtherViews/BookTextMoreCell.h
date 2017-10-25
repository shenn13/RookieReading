//
//  BookTextMoreCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TextBook.h"

#import "RecommendBookModel.h"

@class BookTextMoreCell;
@protocol BookTextMoreCellDelegate <NSObject>

-(void)moreTextBook:(BookTextMoreCell *)moreCell didClickCollect:(TextBook *)textBook;

@end

@interface BookTextMoreCell : UITableViewCell

+(BookTextMoreCell *)textMoreCell:(UITableView *)tableView;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)TextBook *textBook;

/**
 *  推荐书单
 */
@property (nonatomic,strong)RecommendBookModel *recommentBook;

@property (nonatomic,weak)id<BookTextMoreCellDelegate> delegate;

@end
