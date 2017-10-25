//
//  ComicListViewController.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"

@protocol ComicListVCDelegate <NSObject>

-(void)changeReaderComicWithComicId:(NSString *)comicId;

@end

@interface ComicListViewController : ZXBaseTableViewController

@property (nonatomic,copy)NSString *bookId;
/**
 *  当前正在阅读的章节
 */
@property (nonatomic,copy)NSString *comicId;

@property (nonatomic,weak)id<ComicListVCDelegate> delegate;

@end
