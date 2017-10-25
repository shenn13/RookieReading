//
//  TextMenuModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,GenderType){
    GenderTypeOfMale,  // 男
    GenderTypeOfFemale, // 女
    GenderTypeOfPress,  // 出版
    GenderTypeOfOther
};

@interface TextMenuModel : NSObject

@property (nonatomic,assign)AppApiType type;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,assign)NSInteger bookCount;

// male  female  press
@property (nonatomic,assign)GenderType gender;

// 子分类数组
@property (nonatomic,strong)NSArray *mins;

// 图书采用
@property (nonatomic,copy)NSString *imgMenuId;

+(NSMutableArray *)toMenuModelAry:(NSArray *)ary;

@end
