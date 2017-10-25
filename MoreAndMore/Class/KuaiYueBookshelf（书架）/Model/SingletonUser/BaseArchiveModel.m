//
//  BaseArchiveModel.m
//  schoolfriends
//
//  Created by Silence on 16/4/18.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BaseArchiveModel.h"
#import "MJExtension.h"

@implementation BaseArchiveModel

#pragma mark 归档NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encode:aCoder];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    [self decode:aDecoder];
    
    return self;
}

@end
