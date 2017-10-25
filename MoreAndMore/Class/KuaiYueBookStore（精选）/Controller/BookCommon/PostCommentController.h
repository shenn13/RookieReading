//
//  PostCommentController.h
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseViewController.h"

#import "BookImageComent.h"

@protocol PostCommentControllerDelegate <NSObject>

-(void)kuaiKanPostComment:(BookImageComent *)kuaiKanComment;

@end

@interface PostCommentController : ZXBaseViewController

+(PostCommentController *)postCommentController:(NSString *)placeHolder isReply:(BOOL)isReply appType:(AppApiType)type;

@property (nonatomic,assign)BOOL isReply;

@property (nonatomic,copy)NSString *placeHolder;

@property (nonatomic,assign)AppApiType appType;

/**
 *  快看评论对象
 */
@property (nonatomic,strong)BookImageComent *kuaiKanComment;

@property (nonatomic,weak)id<PostCommentControllerDelegate> delegate;

@end
