//
//  ZXLoopScrollView.m
//  MoreAndMore
//
//  Created by Silence on 16/6/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXLoopScrollView.h"
#import "ZXShowPageShapeView.h"

@interface ZXLoopScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ZXShowPageShapeView *page;

@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSMutableArray *showPictureImageArray;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZXLoopScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImage *backImage = [UIImage imageNamed:@"back_day.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:backImage];
        
        [self setScrollViewParameter];
        [self scrollViewAddContentView];
        [self addElement];
        self.scrollView.delegate = self;
        [self startTimer];
    }
    return self;
}

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    _page.pageSize = _modelArray.count;
    [self resetScrollViewContentLocation];
}

#pragma mark 重置ImageView位置
- (void)resetScrollViewContentLocation
{
    self.page.currentPage = _index;
    
    for (int i = 0; i < self.showPictureImageArray.count; i ++)
    {
        NSInteger index = _index - 1 + i;
        if (index < 0) {
            index = self.modelArray.count + index;
        }else if(index >= self.modelArray.count){
            index = index - self.modelArray.count;
        }
        UIImageView *imageView = self.showPictureImageArray[i];
        id currentModel = self.modelArray[index];
        
        if ([currentModel isKindOfClass:[UIImage class]])
        {
            [imageView setImage:(UIImage *)currentModel];
        }
        else
        {
            NSURL *currentURL = nil;
            if ([currentModel isKindOfClass:[AdvertModel class]])
            {
                AdvertModel *advert = (AdvertModel *)currentModel;
                currentURL = [NSURL URLWithString:advert.pic];
            }
            else if ([currentModel isKindOfClass:[Banner class]])
            {
                Banner *banner = (Banner *)currentModel;
                currentURL = [NSURL URLWithString:banner.pic];
            }
            else if ([currentModel isKindOfClass:[NSString class]])
            {
                currentURL = [NSURL URLWithString:(NSString *)currentModel];
            }
            
            [imageView sd_setImageWithURL:currentURL placeholderImage:self.placeholderImage];
        }

        imageView.layer.masksToBounds = YES;
    }
    
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}

#pragma mark 启动计时器
- (void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:4.0 target:self
                                   selector:@selector(nextImageViewForScrollView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark 向右翻页
- (void)nextImageViewForScrollView
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * 2, 0) animated:YES];
}

#pragma mark - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / self.scrollView.width;
    CGFloat c = fmodf(scrollView.contentOffset.x, self.scrollView.width);
    if (index == 1 || c != 0 || !self.modelArray) return;
    
    if (index == 0) {
        _index = _index - 1 < 0? (int)self.modelArray.count - 1: _index - 1;
    }else if(index == 2){
        _index = _index + 1 > self.modelArray.count - 1? 0: _index + 1;;
    }
    [self resetScrollViewContentLocation];
}

#pragma mark  用户拖动scrollview时使计时器失效
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark  拖动scrollview结束时计时器开始
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSDate *date = [NSDate dateWithTimeInterval:4.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

#pragma mark 为View添加bar、标签、标签页
- (void)addElement
{
    //添加page
    _page = [[ZXShowPageShapeView alloc] initWithFrame:CGRectMake(0, self.height - 10, self.width, 5)];
    _page.selectedItemColor = [UIColor whiteColor];
    _page.normalItemColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    _page.pageSize = 5;
    [self addSubview:_page];
}
#pragma mark 为ScrollView设置属性
- (void)setScrollViewParameter{
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:YES];
}

#pragma mark 为ScrollView添加内容元素
- (void)scrollViewAddContentView
{
    self.showPictureImageArray = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 3; i++)
    {
        CGRect rect = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, VIEW_HEIGHT(self));
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.image = self.placeholderImage;
        imageView.userInteractionEnabled = YES;
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClickAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
        [self.showPictureImageArray addObject:imageView];
    }
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}


#pragma mark - 导航栏按钮点击事件
-(void)imageViewClickAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(loopScrollView:clickIndex:)])
    {
        [self.delegate loopScrollView:self clickIndex:_index];
    }
}

#pragma mark 懒加载
- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(3 * SCREEN_WIDTH, 0);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark 默认占位图片
- (UIImage *)placeholderImage
{
    if (_placeholderImage == nil)
    {
        _placeholderImage = [UIImage imageWithColor:THEME_TINTCOLOR andSize:CGSizeMake(SCREEN_WIDTH, self.frame.size.height)];
        _placeholderImage = DEFAULT_BG;
    }
    return _placeholderImage;
}


@end
