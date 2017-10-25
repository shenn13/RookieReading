//
//  ZXJumpToControllerManager.h
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ZXJumpToControllerManager : NSObject

singleton_interface(ZXJumpToControllerManager)

@property (nonatomic, strong) UINavigationController *jumpNavigation;

@end
