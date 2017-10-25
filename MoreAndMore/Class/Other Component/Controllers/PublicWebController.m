//
//  PublicWebController.h
//  WCLDConsulting
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "PublicWebController.h"

@interface PublicWebController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIProgressView *progress;

@property (nonatomic,weak)UIWebView *webView;

@end

@implementation PublicWebController

-(UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        _progress.progressTintColor = THEME_COLOR;
    }
    return _progress;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.detailTitle isEqualToString:@""] || self.detailTitle.length < 1) {
        self.title = @"详情";
    }else{
        self.title = self.detailTitle;
    }

    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectZero];
    // 设置某些数据变为链接形式，这个枚举可以设置如电话号，地址，邮箱等转化为链接
    web.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress;
    // 设置是否使用内联播放器播放视频
    web.allowsInlineMediaPlayback = YES;
    web.scrollView.showsHorizontalScrollIndicator = NO;
    web.scrollView.showsVerticalScrollIndicator = NO;
    web.scalesPageToFit = YES;
    web.delegate = self;
    [self.view addSubview:web];
    self.webView = web;
    
    [self.view addSubview:self.progress];

    if (self.detailURL.length > 0)
    {
        NSURL *url = [[NSURL alloc] initWithString:self.detailURL];
        
        [web loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)setShowType:(ShowHtmlType)showType
{
    _showType = showType;
    
    switch (showType)
    {
        case ShowHtmlTypeOfUS:
            self.detailTitle = @"关于我们";
            break;
        case ShowHtmlTypeOfUserRules:
            self.detailTitle = @"用户守则";
            break;
        default:
            break;
    }
    
    NSString *urlString = @"http://www.cnblogs.com/silence-wzx/";
    self.detailURL = urlString;
    
}

-(void)loadUrlAgain
{
    if (self.detailURL.length > 0)
    {
        NSURL *url = [[NSURL alloc]initWithString:self.detailURL];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideProgress];
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        [self showTextWithState:ActivityHUDStateFailed inView:KEY_WINDOW text:@"很抱歉\n您的网络出故障了!"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 加载失败提供重新加载按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadUrlAgain)];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.progress setProgress:0.4 animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progress setProgress:1 animated:YES];
    [self performSelector:@selector(hideProgress) withObject:self afterDelay:1.5];
}

/**
 *  隐藏进度条
 */
-(void)hideProgress
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.progress setProgress:0 animated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
