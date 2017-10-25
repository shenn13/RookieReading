//
//  PostHelpEachOtherController.h
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseViewController.h"

#import "TextReviewModel.h"

@protocol PostHelpEachOtherDelelgate <NSObject>

-(void)zhuiShuPostComment:(TextReviewModel *)reviewModel;

@end

@interface PostHelpEachOtherController : ZXBaseViewController

@property (nonatomic,assign)BOOL isReply;

@property (nonatomic,copy)NSString *placeHolder;

@property (nonatomic,assign)AppApiType appType;

/**
 *  评论对象
 */
@property (nonatomic,strong)TextReviewModel *reviewModel;

@property (nonatomic,weak)id<PostHelpEachOtherDelelgate> delegate;

@end
