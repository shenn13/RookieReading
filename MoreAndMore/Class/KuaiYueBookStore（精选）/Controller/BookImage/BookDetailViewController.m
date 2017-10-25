//
//  BookDetailViewController.m
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailView.h"

@interface BookDetailViewController ()

@property (nonatomic,weak)BookDetailView *bookView;

@end

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BookDetailView *bookView = [[BookDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bookView.book = self.book;
    [self.view addSubview:bookView];
    self.bookView = bookView;
    
    // 数据请求
    [self bookDetailRequest];
}

-(void)bookDetailRequest
{
    ZXRequestTool *request = [ZXRequestTool new];
    
    NSDictionary *param;
    if (self.book.idd.length > 0) {
        param = @{@"bookId":self.book.idd};;
    }
    else if (self.book.idd.length < 1 && self.book.target_id.length > 0) {
        param = @{@"bookId":self.book.target_id};
    }
    
    if (param.count < 1) return;
    
    [request baseRequestWithMethod:[request getMethodWithType:URLTypeOfThree param:param] requestType:RequestTypeOfKuaiKan params:@{@"sort":@(self.book.order)} completion:^(NSDictionary *responseObject) {
        if (SUCCESS) {
            BookDetail *detail = [BookDetail toBookDetailModel:responseObject[@"data"]];
            if (detail) {
                self.bookView.detail = detail;
            }
        }
    } failure:^(NSError *error) {
        [self showText:REQUESTTIPFAI inView:self.view];
    }];
}

#pragma mark - 页面生命周期
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
