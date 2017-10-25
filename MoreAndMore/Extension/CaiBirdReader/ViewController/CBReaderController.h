//
//  CBReaderController.h
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBReaderView.h"
#import "CBReaderInfoTool.h"

#import "ChalpterDetailModel.h"

@interface CBReaderController : UIViewController

@property (nonatomic,strong)CBReaderView *readerView;
@property (nonatomic,strong)CBReaderInfoTool *infoTool;

@end
