//
//  CircleDescriptionView.h
//  WCLDConsulting
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDTimeLineCellModel.h"

typedef NS_ENUM(NSInteger,OperationMenu){
    OperationMenuOfDelete,  // 删除说说
    OperationMenuOfDianZan,  // 点赞
    OperationMenuOfComment  // 评论
};

#define DES_H 20


@interface CircleDescriptionView : UIView

@property (nonatomic,strong)SDTimeLineCellModel *descriptionModel;

@property (nonatomic,copy) void (^operationMenuBlock)(OperationMenu menu);


@end
