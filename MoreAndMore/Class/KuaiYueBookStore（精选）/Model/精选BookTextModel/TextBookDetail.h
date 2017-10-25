//
//  TextBookDetail.h
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextBookDetail : NSObject

/**
 *  扩展属性
 */
@property (nonatomic,assign)BOOL isCollect;

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,assign)NSInteger le;

@property (nonatomic,assign)NSInteger allowMonthly;
@property (nonatomic,assign)NSInteger allowVoucher;

@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *cat;
@property (nonatomic,assign)NSInteger chaptersCount;
@property (nonatomic,assign)NSInteger followerCount;
@property (nonatomic,copy)NSString *cover;
/**
 *  何种设备发布的:"iPhone 4S"
 */
@property (nonatomic,copy)NSString *creater;
@property (nonatomic,assign)NSInteger donate;
@property (nonatomic,strong)NSArray *gender;
@property (nonatomic,assign)NSInteger hasCp;
@property (nonatomic,assign)NSInteger isSerial;
@property (nonatomic,copy)NSString *lastChapter;
@property (nonatomic,assign)NSInteger latelyFollower;
@property (nonatomic,assign)NSInteger latelyFollowerBase;
/**
 *  长简介
 */
@property (nonatomic,copy)NSString *longIntro;
@property (nonatomic,copy)NSString *majorCate;
@property (nonatomic,assign)NSInteger minRetentionRatio;
@property (nonatomic,copy)NSString *minorCate;
@property (nonatomic,assign)NSInteger postCount;
@property (nonatomic,copy)NSString *retentionRatio;
@property (nonatomic,copy)NSString *serializeWordCount;
@property (nonatomic,strong)NSArray *tags;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *updated;
@property (nonatomic,assign)NSInteger wordCount;

+(TextBookDetail *)toTextBookDetail:(NSDictionary *)dict;

/*
"_id" = 50b45582aab49e9d04000035;
"_le" = 1;
allowMonthly = 1;
allowVoucher = 1;
author = "\U867e\U7c73XL";
cat = "\U5947\U5e7b";
chaptersCount = 2186;
cover = "/agent/http://img.17k.com/images/bookcover/2012/548/2/109666.jpg";
creater = "iPhone 4S";
donate = 0;
followerCount = 8490;
gender =     (
              male
              );
hasCp = 1;
isSerial = 0;
lastChapter = "\U7b2c\U4e8c\U5343\U4e00\U767e\U4e03\U5341\U516b\U7ae0 \U4e2d\U5174\U9e3f\U8499";
latelyFollower = 19805;
latelyFollowerBase = 0;
longIntro = "";
majorCate = "\U7384\U5e7b";
minRetentionRatio = 0;
minorCate = "\U5f02\U754c\U5927\U9646";
postCount = 1617;
retentionRatio = "56.86";
serializeWordCount = "-1";
tags =     (
            "\U91cd\U751f",
            "\U7384\U5e7b\U5947\U5e7b",
            "\U70ed\U8840",
            "\U67b6\U7a7a",
            "\U5f02\U754c\U5927\U9646",
            "\U5f02\U4e16\U5927\U9646",
            "\U5947\U9047",
            "\U541e\U566c\U82cd\U7a79",
            "\U4fee\U70bc"
            );
title = "\U541e\U566c\U82cd\U7a79";
updated = "2014-08-20T08:28:05.935Z";
wordCount = 6994548;
*/
 
@end
