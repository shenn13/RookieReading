//
//  Banner.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "Banner.h"
#import "NSObject+ImageUrlManager.h"

@implementation Banner

+(Banner *)handleImageUrl:(Banner *)banner
{
    banner.pic = [Banner imageUrlIfNeedExtension:banner.pic extension:PIC_EXTENSION];
    return banner;
}

@end
