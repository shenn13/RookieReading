//
//  BookTextHeaderView.h
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TextBookDetail.h"
#import "TextBook.h"

#define TEXT_HEADERHEI      300.f

@protocol BookTextHeaderViewDelegate <NSObject>

-(void)headerViewDidClickMenu;

-(void)headerViewDidClickReader;

-(void)headerViewDidClickShare;

@end

@interface BookTextHeaderView : UIView

+(BookTextHeaderView *)bookTextHeader;

@property (nonatomic,strong)TextBookDetail *detail;

@property (nonatomic,strong)TextBook *textBook;

@property (nonatomic,weak)id<BookTextHeaderViewDelegate> delegate;

@end
