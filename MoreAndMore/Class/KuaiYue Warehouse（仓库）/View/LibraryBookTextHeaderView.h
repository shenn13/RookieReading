//
//  LibraryBookTextHeaderView.h
//  MoreAndMore
//
//  Created by apple on 16/10/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BOOKTEXT_HEADER @"BOOKTEXT_HEADER"

@protocol LibraryBookTextHeaderViewDelegate <NSObject>

-(void)didClickHeaderLikeSetingAction;

@end

@interface LibraryBookTextHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnConfig;
@property (weak, nonatomic) IBOutlet UIImageView *imaSetIcon;

@property (nonatomic,weak)id<LibraryBookTextHeaderViewDelegate> delegate;

@end
