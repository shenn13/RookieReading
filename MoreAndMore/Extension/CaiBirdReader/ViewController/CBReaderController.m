//
//  CBReaderController.m
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBReaderController.h"

@interface CBReaderController ()

@end

@implementation CBReaderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 内容显示区
    [self.view addSubview:self.readerView];
    
    // 章节标题显示区域
    [self.view addSubview:self.infoTool];
}

-(CBReaderView *)readerView{
    if (_readerView == nil) {
        _readerView = [[CBReaderView alloc] initWithFrame:[CBReaderView textContentRect]];
    }
    return _readerView;
}

-(CBReaderInfoTool *)infoTool{
    if (_infoTool == nil) {
        _infoTool = [[CBReaderInfoTool alloc] initWithFrame:[CBReaderInfoTool infoToolRect]];
    }
    return _infoTool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
