//
//  MyLikeSettingViewController.h
//  MoreAndMore
//
//  Created by apple on 16/10/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"

typedef NS_ENUM(NSInteger,MyLikeType){
    MyLikeTypeOfMale,
    MyLikeTypeOfFemale,
    MyLikeTypeOfCortoon
};

@protocol MyLikeSettingViewControllerDelegate <NSObject>

-(void)myLikeSettingChangeAction:(MyLikeType)likeType;

@end

@interface MyLikeSettingViewController : ZXBaseTableViewController

@property (nonatomic,assign)MyLikeType likeType;

@property (nonatomic,weak)id<MyLikeSettingViewControllerDelegate> delegate;

@end
