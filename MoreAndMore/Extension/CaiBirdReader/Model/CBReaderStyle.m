//
//  CBReaderStyle.m
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBReaderStyle.h"

@implementation CBReaderStyle

+(instancetype)shareStyle
{
    static CBReaderStyle *readerStyle;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        readerStyle = [[CBReaderStyle alloc] init];
    });
    
    return readerStyle;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.transitionType = UIPageViewControllerTransitionStylePageCurl;
        self.orientation = UIPageViewControllerNavigationOrientationHorizontal;
        self.font = [UIFont systemFontOfSize:18.f];
        self.textColor = [UIColor blackColor];
        // 背景色池
        _backColorPool = [@[[UIColor whiteColor],
                           [UIColor colorWithHexString:@"0xCEDFEC"],
                           [UIColor colorWithHexString:@"0xE0EED8"],
                           [UIColor colorWithHexString:@"0xDFC49F"],
                           [UIColor colorWithHexString:@"0x42302C"],
                           [UIColor colorWithHexString:@"0xE0F6FE"],
                           [UIColor colorWithHexString:@"0xECECEC"],
                           [UIColor redColor],
                           [UIColor orangeColor]] mutableCopy];
        self.backColor = _backColorPool[0];
    }
    return self;
}

+(NSDictionary *)coreTextAttributes
{
    CBReaderStyle *style = [CBReaderStyle shareStyle];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = style.font.pointSize/2;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *dic = @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:style.font,NSForegroundColorAttributeName:style.textColor};
    return dic;
}

@end
