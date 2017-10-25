//
//  AdvertModel.m
//  MoreAndMore
//
//  Created by Silence on 16/6/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "AdvertModel.h"

@implementation AdvertModel

+(NSArray *)advertArrWithDataArr:(NSArray *)arr
{
    return [AdvertModel objectArrayWithKeyValuesArray:arr];
}

+(NSMutableArray *)handleImageUrlIfNeed:(NSMutableArray *)dataArr
{
    for (AdvertModel *model in dataArr)
    {
        if ([model.pic hasSuffix:@".webp"])
        {
            NSString *newPic = [NSString stringWithFormat:@"%@%@",model.pic,PIC_EXTENSION];
            model.pic = newPic;
        }
    }
    return dataArr;
}

@end
