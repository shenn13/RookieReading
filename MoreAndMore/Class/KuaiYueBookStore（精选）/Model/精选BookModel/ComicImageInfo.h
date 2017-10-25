//
//  ComicImageInfo.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicImageInfo : NSObject

@property (nonatomic,assign)double width;

@property (nonatomic,assign)double height;

/**
 *  缩放之后的高度比
 */
@property (nonatomic,assign)double scaleHeight;

@end
