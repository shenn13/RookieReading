//
//  ZXRequestTool.m
//  MoreAndMore
//
//  Created by Silence on 16/6/4.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXRequestTool.h"

#define METHOD @"GET"

@implementation ZXRequestTool

-(void)baseRequestWithMethod:(NSString *)method requestType:(RequestType)type params:(NSDictionary *)params completion:(void (^)(NSDictionary *responseObject))success failure:(void(^)(NSError *error))failure
{
    
    NSString *urlStr = @"";
    if (type == RequestTypeOfKuaiKan) {
        urlStr = SERVERURL_KUAIKAN;
    }else if (type == RequestTypeOfZhuiShu){
        urlStr = SERVERURL_ZHUISHU;
    }else if (type == RequestTypeOfZhuiShuChalpter){
        urlStr = SERVERURL_ZHUISHU_CHALPTER;
    }else if (type == RequestTypeOfOther){
        urlStr = @"";
    }
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,method];
    
    if (params.count > 0)
    {
        NSMutableString *urlMutableStr=[NSMutableString string];
        for (int i = 0;i < params.allKeys.count;i++)
        {
            NSString *key = params.allKeys[i];
            id value = params[key];
            if (i == 0) {
                urlMutableStr = [NSMutableString stringWithFormat:@"?%@=%@",key,value];
            }else{
                [urlMutableStr appendFormat:@"&%@=%@",key,value];
            }
        }
        urlStr = [urlStr stringByAppendingString:urlMutableStr];
    }
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    NSLog(@"GET请求:%@",urlStr);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dict);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    }];
    [dataTask resume];
}

-(NSString *)getMethodWithType:(URLType)type param:(NSDictionary *)param
{
    if (type == URLTypeOfOne){  // 广告图
        return @"banners?";
    }else if (type == URLTypeOfTwo){
        return @"topic_lists/mixed/new?";  // 主页列表
    }else if (type == URLTypeOfThree){
        return [@"topics" stringByAppendingPathComponent:param[@"bookId"]];  // 书籍界面（章节列表）
    }else if (type == UrlTypeOfFour){
        return [@"comics" stringByAppendingPathComponent:param[@"comicId"]];  // 书籍阅读界面（图片）
    }else if (type == URLTypeOfFive){
        return [NSString stringWithFormat:@"comics/%@/comments/%@",param[@"comicId"],param[@"finalId"]]; // 书籍阅读界面（底部评论列表）
    }else if (type == URLTypeOfSix){
        return [NSString stringWithFormat:@"users/%@",param[@"atUserId"]];
    }
    return @"";
}

-(NSString *)v2GetMethodWithType:(URLType)type param:(NSDictionary *)param
{
    if (type == URLTypeOfOne){  // V2 广告页 + 列表数据
        return @"topic_new/discovery_list?";
    }else if (type == URLTypeOfTwo){
        return @"topic_lists/mixed/new?";  // 更多数据列表
    }else if (type == URLTypeOfThree){
        return [@"topics" stringByAppendingPathComponent:param[@"bookId"]];  // 书籍界面
    }else if (type == UrlTypeOfFour){
        return [@"comics" stringByAppendingPathComponent:param[@"comicId"]];  // 书籍阅读界面（图片）
    }else if (type == URLTypeOfFive){
        return [NSString stringWithFormat:@"comics/%@/comments/%@",param[@"comicId"],param[@"finalId"]]; // 书籍阅读界面（底部评论列表）
    }else if (type == URLTypeOfSix){
        return [NSString stringWithFormat:@"users/%@",param[@"atUserId"]];  // 快看个人中心
    }else if (type == URLTypeOfSeven){
        return @"topic_new/lists/get_by_tag";  // 快看书库列表筛选
    }else if (type == URLTypeOfEight){  // 快看搜索
        return @"topics/search";
    }
    return @"";
}

-(NSString *)getTextMethodWithType:(URLType)type param:(NSDictionary *)param
{
    if (type == URLTypeOfOne){  // 排行榜列表获取(精选)
        return @"ranking/gender";
    }else if (type == URLTypeOfTwo){  // 榜单列表获取
        return [NSString stringWithFormat:@"ranking/%@",param[@"totalRankId"]];
    }else if (type == URLTypeOfThree){  // 书籍详情信息获取
        return [NSString stringWithFormat:@"book/%@",param[@"textBookId"]];
    }else if (type == UrlTypeOfFour){  // 书籍热门评论信息请求
        return @"post/review/best-by-book";
    }else if (type == URLTypeOfFive){   // 推荐书单列表
        return [NSString stringWithFormat:@"book-list/%@/recommend",param[@"textBookId"]];
    }else if (type == URLTypeOfSix){  // 主题书单详情
        return [NSString stringWithFormat:@"book-list/%@",param[@"bookThemeId"]];
    }else if (type == URLTypeOfSeven){ // 章节列表（来源）获取
        return @"ctoc";
    }else if (type == URLTypeOfEight){ // 章节列表获取
        return [NSString stringWithFormat:@"btoc/%@",param[@"summaryId"]];
    }else if (type == URLTypeOfNine){  // 分类列表获取
        return @"cats/lv2/statistics";
    }else if (type == URLTypeOfTen){       // 书籍分类列表筛选
        return @"book/by-categories";
    }else if (type == URLTypeOfEleven){    // 主题书单区
        return @"book-list";
    }else if (type == URLTypeOfTwelve){    // 书评区
        return @"post/review";
    }else if (type == URLTypeOfThirteen){  // 书荒互助
        return @"post/help";
    }else if (type == URLTypeOfFourteen){  // 书籍搜索
        return @"book/fuzzy-search";
    }else if (type == URLTypeOfFifteen){   // 书籍章节内容
        return [NSString stringWithFormat:@"chapter/%@",param[@"chalpterLink"]];
    }
    return @"";
}

@end
