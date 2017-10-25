//
//  CBMenuPanel.m
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBMenuPanel.h"
#import "CBReaderStyle.h"

@interface CBMenuPanel ()

// 上面的
@property (nonatomic,strong)UIView *topBar;

// 下面的
@property (nonatomic,strong)UIView *toolBar;
@property (nonatomic,strong)UISlider *readerSlider;

// 主题按钮数组
@property (nonatomic,strong)NSMutableArray *themeMenuArr;

@end

#define MAX_FONT_SIZE 28
#define MIN_FONT_SIZE 16

#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"

@implementation CBMenuPanel

-(instancetype)init
{
    if (self = [super init])
    {
        // 屏幕宽
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        
        UIColor *themeColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        // 顶部工具栏
        self.topBar.backgroundColor = themeColor;
        [self addSubview:self.topBar];
        
        // 底部工具栏
        self.toolBar.backgroundColor = themeColor;
        [self addSubview:self.toolBar];
        
        // 手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];

        // 默认隐藏
        [self hiddenPanelMenu:NO];
    }
    return self;
}

-(UIView *)topBar
{
    if (_topBar == nil) {
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64.f)];
        CGFloat menuWH = 40.f;
        CGFloat topMar = 23.f;
        CGFloat horMar = 10.f;
        // 关闭按钮
        UIButton *btnClose = [[UIButton alloc] init];
        [btnClose setImage:[UIImage imageNamed:@"common_back_white"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:btnClose];
        
        // 更多按钮
        UIButton *btnMore = [[UIButton alloc] init];
        [btnMore setImage:[UIImage imageNamed:@"menu_list"] forState:UIControlStateNormal];
        [btnMore addTarget:self action:@selector(moreMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:btnMore];
        
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(menuWH, menuWH));
            make.left.mas_equalTo(horMar);
            make.top.mas_equalTo(topMar);
        }];
        [btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(menuWH, menuWH));
            make.right.mas_equalTo(-horMar);
            make.top.mas_equalTo(topMar);
        }];
    }
    return _topBar;
}

-(UIView *)toolBar
{
    if (_toolBar == nil) {
        CGFloat toolH = 160.f;
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - toolH, [UIScreen mainScreen].bounds.size.width, toolH)];
        // 上一章、下一章
        UIButton *btnLast = [self createPageChangeMenu:@"上一章"];
        UIButton *btnNext = [self createPageChangeMenu:@"下一章"];
        [_toolBar addSubview:btnLast];
        [_toolBar addSubview:btnNext];
        // 进度条
        UISlider *progress = [[UISlider alloc] init];
        progress.minimumTrackTintColor = [UIColor redColor];
        progress.maximumTrackTintColor = [UIColor whiteColor];
        [progress setThumbImage:[UIImage imageNamed:@"tipIcon_Tweet"] forState:UIControlStateNormal];
        // 只需要监听最后一次<进度更新>
        [progress addTarget:self action:@selector(readerSliderProgressChange:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:progress];
        self.readerSlider = progress;
        // 背景切换
        UIScrollView *scrollMenu = [self createThemeChangeMenus];
        [_toolBar addSubview:scrollMenu];
        // 字体大小切换
        UIButton *fontMenuDecrease = [self createBottomMenu:@"reader_font_decrease" isBackImage:YES];
        fontMenuDecrease.tag = 666;
        UIButton *fontMenuIncrease = [self createBottomMenu:@"reader_font_increase" isBackImage:YES];
        fontMenuIncrease.tag = 667;
        [_toolBar addSubview:fontMenuDecrease];
        [_toolBar addSubview:fontMenuIncrease];
        
        // 底部扩展菜单
        UIButton *extMenuLeft = [self createBottomMenu:@"tipIcon_Task" isBackImage:NO];
        extMenuLeft.tag = 777;
        UIButton *extMenuRight = [self createBottomMenu:@"tipIcon_Tweet" isBackImage:NO];
        extMenuRight.tag = 778;
        [_toolBar addSubview:extMenuLeft];
        [_toolBar addSubview:extMenuRight];
        
        CGFloat horMar = 4.f;
        CGFloat rowH = 44.f;
        // 页数控制
        [btnLast mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(horMar);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, rowH));
        }];
        [btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(btnLast);
            make.width.mas_equalTo(btnLast);
            make.height.mas_equalTo(btnLast);
        }];
        [progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnLast.mas_right).offset(horMar);
            make.right.mas_equalTo(btnNext.mas_left).offset(-horMar);
            make.centerY.mas_equalTo(btnLast);
        }];
        [scrollMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(0);
            make.height.mas_equalTo(rowH);
        }];
        [fontMenuDecrease mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60.f, 36.f));
            make.bottom.mas_equalTo(-horMar);
            make.right.mas_equalTo(scrollMenu.mas_centerX).offset(-horMar*2);
        }];
        [fontMenuIncrease mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fontMenuDecrease);
            make.height.mas_equalTo(fontMenuDecrease);
            make.centerY.mas_equalTo(fontMenuDecrease);
            make.left.mas_equalTo(scrollMenu.mas_centerX).offset(horMar*2);
        }];
        [extMenuLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(horMar*1.5);
            make.size.mas_equalTo(CGSizeMake(rowH, rowH));
            make.centerY.mas_equalTo(fontMenuDecrease);
        }];
        [extMenuRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-horMar*1.5);
            make.size.mas_equalTo(CGSizeMake(rowH, rowH));
            make.centerY.mas_equalTo(fontMenuDecrease);
        }];
    }
    return _toolBar;
}

-(UIButton *)createPageChangeMenu:(NSString *)title
{
    UIButton *pageMenu = [[UIButton alloc] init];
    pageMenu.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [pageMenu setTitle:title forState:UIControlStateNormal];
    [pageMenu addTarget:self action:@selector(pageChangeMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    return pageMenu;
}

-(UIScrollView *)createThemeChangeMenus
{
    UIScrollView *menuScroll = [[UIScrollView alloc] init];
    menuScroll.showsVerticalScrollIndicator = NO;
    menuScroll.showsHorizontalScrollIndicator = NO;
    menuScroll.backgroundColor = [UIColor clearColor];
    // 主题色池
    CBReaderStyle *readerStyle = [CBReaderStyle shareStyle];
    // 默认选中颜色
    NSInteger backChooseIndex = [readerStyle.backColorPool indexOfObject:readerStyle.backColor];
    static CGFloat menuWH = 36.f;
    CGFloat horMar = 14.f;
    CGFloat margin = 10.f;
    self.themeMenuArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < readerStyle.backColorPool.count; i ++)
    {
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        themeButton.layer.cornerRadius = 2.0f;
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [themeButton setBackgroundColor:readerStyle.backColorPool[i]];
        
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateSelected];
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateHighlighted];
        
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [menuScroll addSubview:themeButton];
        if (backChooseIndex == i) {
            themeButton.selected = YES;
        }

        // 布局
        [themeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(menuWH, menuWH));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(horMar);
        }];
        horMar += menuWH + margin;
        
        [self.themeMenuArr addObject:themeButton];
    }
    menuScroll.contentSize = CGSizeMake(horMar + margin, menuWH);
    return menuScroll;
}

-(UIButton *)createBottomMenu:(NSString *)imageName isBackImage:(BOOL)isBack
{
    UIButton *bottomMenu = [[UIButton alloc] init];
    UIImage *img = [UIImage imageNamed:imageName];
    if (isBack) {
        [bottomMenu setBackgroundImage:img forState:UIControlStateNormal];
    }else{
        [bottomMenu setImage:img forState:UIControlStateNormal];
    };
    [bottomMenu addTarget:self action:@selector(bottomExtMenuChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    return bottomMenu;
}

#pragma mark - 显示/隐藏

-(void)showPanelMenu:(BOOL)animated
{
    self.userInteractionEnabled = YES;
    CGFloat toolY = [UIScreen mainScreen].bounds.size.height - self.toolBar.mj_h;
    if (animated) {
        [UIView animateWithDuration:0.18 animations:^{
            self.topBar.mj_y = 0;
            self.toolBar.mj_y = toolY;
        } completion:^(BOOL finished) {
            if (finished) {
                _show = YES;
            }
        }];
    }else{
        self.topBar.mj_y = 0;
        self.toolBar.mj_y = toolY;
        _show = YES;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)hiddenPanelMenu:(BOOL)animated
{
    self.userInteractionEnabled = NO;
    CGFloat topY = -64.f;
    CGFloat toolY = [UIScreen mainScreen].bounds.size.height;
    if (animated) {
        [UIView animateWithDuration:0.18 animations:^{
            self.topBar.mj_y = topY;
            self.toolBar.mj_y = toolY;
        } completion:^(BOOL finished) {
            if (finished) {
                _show = NO;
            }
        }];
    }else{
        self.topBar.mj_y = topY;
        self.toolBar.mj_y = toolY;
        _show = NO;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 更新阅读进度

-(void)updateReaderPanelWithChalpters:(NSInteger)chalpterCount readerChalpter:(NSInteger)readerChalpter
{
    self.readerSlider.maximumValue = chalpterCount;
    self.readerSlider.minimumValue = 0;
    self.readerSlider.value = readerChalpter;
    NSLog(@"阅读进度更新:%f",(CGFloat)readerChalpter/(CGFloat)chalpterCount);
}

#pragma mark - 顶部工具栏事件

-(void)closeViewAction:(UIButton *)btnClose
{
    if (self.CBMenuPanleAction) {
        self.CBMenuPanleAction(CBMenuPanelActionTypeClose);
    }
}

-(void)moreMenuAction:(UIButton *)btnMore
{
    if (self.CBMenuPanleAction) {
        self.CBMenuPanleAction(CBMenuPanelActionTypeMore);
    }
}

#pragma mark - 底部工具栏相关事件

-(void)pageChangeMenuAction:(UIButton *)pageMenu
{
    NSString *title = [pageMenu titleForState:UIControlStateNormal];
    if (self.CBMenuPanleAction)
    {
        if ([title isEqualToString:@"上一章"])
        {
            self.CBMenuPanleAction(CBMenuPanelActionTypeLast);
        }
        else
        {
            self.CBMenuPanleAction(CBMenuPanelActionTypeNext);
        }
    }
}

-(void)readerSliderProgressChange:(UISlider *)readerSlider
{
    if (readerSlider.maximumValue <= 0) {
        [self showText:@"书籍资源加载失败" inView:self.superview];
    }
    _jumpChalpterIndex = readerSlider.value;
    if (self.CBMenuPanleAction) {
        self.CBMenuPanleAction(CBMenuPanelActionTypePageJump);
    }
}

-(void)themeButtonPressed:(UIButton *)themeColor
{
    for (UIButton *themeMenu in self.themeMenuArr)
    {
        if (themeMenu.selected) {
            themeMenu.selected = NO;
        }
    }
    themeColor.selected = YES;
    
    CBReaderStyle *style = [CBReaderStyle shareStyle];
    style.backColor = themeColor.backgroundColor;
    
    if (self.CBMenuPanleAction) {
        self.CBMenuPanleAction(CBMenuPanelActionTypeBgChange);
    }
}

-(void)bottomExtMenuChangeAction:(UIButton *)bottomMenu
{
    CBReaderStyle *style = [CBReaderStyle shareStyle];
    CGFloat originSize = style.font.pointSize;
    
    CBMenuPanelActionType actionType = CBMenuPanelActionTypeOther;
    
    if (bottomMenu.tag == 666)
    {
        // 字体减小
        originSize -= 1;
        if (originSize < MIN_FONT_SIZE) {
            [self showText:MIN_TIPS inView:self.superview];
            return;
        }
        style.font = [UIFont systemFontOfSize:originSize];
        actionType = CBMenuPanelActionTypeFontChange;
    }
    else if(bottomMenu.tag == 667)
    {
        // 字体变大
        originSize += 1;
        if (originSize > MAX_FONT_SIZE) {
            [self showText:MAX_TIPS inView:self.superview];
            return;
        }
        style.font = [UIFont systemFontOfSize:originSize];
        actionType = CBMenuPanelActionTypeFontChange;
    }
    else if(bottomMenu.tag == 777)
    {
        [self hiddenPanelMenu:YES];
        // 左边扩展
        actionType = CBMenuPanelActionTypeExtLeftMenu;
    }
    else if(bottomMenu.tag == 778)
    {
        [self hiddenPanelMenu:YES];
        // 右边扩展
        actionType = CBMenuPanelActionTypeExtRightMenu;
    }
    
    if (self.CBMenuPanleAction) {
        self.CBMenuPanleAction(actionType);
    }
}

#pragma mark - 手势

-(void)backgroundTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
    CGRect topBarRect = [self convertRect:self.topBar.bounds fromView:self.topBar];
    CGRect toolBarRect = [self convertRect:self.toolBar.bounds fromView:self.toolBar];
    if (!CGRectContainsPoint(topBarRect, touchPoint) && !CGRectContainsPoint(toolBarRect, touchPoint))
    {
        if (self.show) {
            [self hiddenPanelMenu:YES];
        }else{
            [self showPanelMenu:YES];
        }
    }
}

@end
