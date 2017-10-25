//
//  SDTimeLineCellModel.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TimeLineModelType){
    TimeLineModelTypeOfTextOrImg,  // 文字 + 图片
    TimeLineModelTypeOfBookShare  // 文字 + 分享对象
};

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel;

@interface SDTimeLineCellModel : NSObject

@property (nonatomic,assign)AppApiType appType;

@property(nonatomic,assign)TimeLineModelType modelType;

//头像
@property (nonatomic, copy) NSString *iconName;
//名字
@property (nonatomic, copy) NSString *name;
//内容
@property (nonatomic, copy) NSString *msgContent;
//自己是否点赞
@property (nonatomic, assign, getter = isLiked) BOOL liked;
//是否显示展示删除按钮
@property (nonatomic,assign, getter = isShowDel) BOOL showDel;
// 发布日期描述
@property (nonatomic,copy)NSString *timeDescription;
// 点赞数
@property (nonatomic,copy)NSString *likesCount;

@property (nonatomic,copy)NSString *replyUserId;

//是不是关闭
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic,assign)BOOL shouldShowMoreButton;

//照片列表
@property (nonatomic, strong) NSArray *picNamesArray;
//点赞列表
@property (nonatomic, strong) NSMutableArray<SDTimeLineCellLikeItemModel *> *likeItemsArray;
//评论列表
@property (nonatomic, strong) NSMutableArray<SDTimeLineCellCommentItemModel *> *commentItemsArray;

// 文字类书籍扩展属性（是否精选）
@property (nonatomic,copy)NSString *state;

@end

/**
 *  点赞模型
 */
@interface SDTimeLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@end

/**
 *  评论模型（暂不用）
 */
@interface SDTimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, assign) NSInteger user_id;  // 消息记录id

@end