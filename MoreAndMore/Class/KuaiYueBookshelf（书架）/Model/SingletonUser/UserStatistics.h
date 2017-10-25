//
//  UserStatistics.h
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"

/*
    private Integer userId;//用户id
	private Integer srcActCount;//发布活动总数
	private Integer partInActCount;//参与活动总数
	private Integer reportedCount;//被举报总次数
	private Integer followCount;//关注总人数
	private Integer fansCount;//拥有粉丝总数
	private Date updateTime;//更新时间
 */

@interface UserStatistics : BaseArchiveModel

//  用户id
@property (nonatomic,copy)NSString *userId;
//  发布活动总数
@property (nonatomic,assign)NSInteger srcActCount;
//  参与活动总数
@property (nonatomic,assign)NSInteger partInActCount;
//  被举报总次数
@property (nonatomic,assign)NSInteger reportedCount;
//  关注总人数
@property (nonatomic,assign)NSInteger followCount;
//  拥有粉丝总数
@property (nonatomic,assign)NSInteger fansCount;
//  更新时间
@property (nonatomic,assign)NSInteger updateTime;

@end
