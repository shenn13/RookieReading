//
//  ZXRequestTool.h
//  MoreAndMore
//
//  Created by Silence on 16/6/4.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ======追书神器=====
 书籍图片：
 http://statics.zhuishushenqi.com/agent/http://image.cmfu.com/books/2502372/2502372.jpg-coverl
 头像图片：
 http://statics.zhuishushenqi.com/avatar/f9/32/f9329ebd7a1a24ac0c5176faa0fd930a-avatars
 
 */

typedef NS_ENUM(NSInteger,URLType){
    // 快看：广告业+列表数据  追书：排行榜榜单
    URLTypeOfOne = 0,
    // 快看：更多数据列表
    URLTypeOfTwo,
    // 快看：书籍界面
    URLTypeOfThree,
    // 快看：书籍阅读界面（图片）
    UrlTypeOfFour,
    // 快看：书籍阅读界面（评论列表）
    URLTypeOfFive,
    // 快看：个人中心
    URLTypeOfSix,
    
    // 追书：章节列表（来源）获取
    URLTypeOfSeven,
    // 追书：小说列表
    URLTypeOfEight,
    // 追书：分类列表获取
    URLTypeOfNine,
    // 追书：书籍分类列表筛选
    URLTypeOfTen,
    // 追书：主题书单区
    URLTypeOfEleven,
    // 追书：书评区
    URLTypeOfTwelve,
    // 追书：书荒互助
    URLTypeOfThirteen,
    // 追书：书籍搜索
    URLTypeOfFourteen,
    // 追书：书籍章节内容
    URLTypeOfFifteen
};

typedef NS_ENUM(NSInteger,RequestType){
    RequestTypeOfKuaiKan,
    RequestTypeOfZhuiShu,
    RequestTypeOfZhuiShuChalpter,
    RequestTypeOfOther
};

#define STATUSCODE @"code"
#define SUCCESS [responseObject[STATUSCODE] isEqualToNumber:@200]
#define SUCCESS_OK [responseObject[@"ok"] isEqualToNumber:@1]
#define RESULT_MESSAGE responseObject[@"message"]

@interface ZXRequestTool : NSObject

#pragma mark - 漫画接口相关
/**
 *  V1版本漫画接口相关
 */
-(NSString *)getMethodWithType:(URLType)type param:(NSDictionary *)param;

/**
 *  V2漫画版本接口相关
 */
-(NSString *)v2GetMethodWithType:(URLType)type param:(NSDictionary *)param;

#pragma mark - 追书神器接口相关
-(NSString *)getTextMethodWithType:(URLType)type param:(NSDictionary *)param;

-(void)baseRequestWithMethod:(NSString *)method requestType:(RequestType)type params:(NSDictionary *)params completion:(void (^)(NSDictionary *responseObject))success failure:(void(^)(NSError *error))failure;

@end
