//
//  ZXPopView.m
//  schoolfriends
//
//  Created by Silence on 16/3/11.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXPopView.h"

#define POPVIEW_MARGIN 10

#define WIDTH 140
#define ROW_HEIGHT 38

@interface ZXPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)NSArray *icons;

@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,assign)CGPoint origin;
@property (nonatomic,assign)BOOL isAnimation;
@property (nonatomic,assign)TrianglePosition position;

@property (nonatomic,assign)BOOL showSelect;
@property (nonatomic,assign)NSInteger defaultIndex;

@property (nonatomic,copy)void(^action)(NSInteger idx) ;

@end

@implementation ZXPopView

- (instancetype)init
{
    if (self = [super init])
    {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [UIColor colorWithHue:0
                                          saturation:0
                                          brightness:0 alpha:0.1];
        // 添加背景手势事件
        UIView *BGView = [[UIView alloc] initWithFrame:self.frame];
        BGView.backgroundColor = [UIColor clearColor];
        [self addSubview:BGView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BGTapAction:)];
        [BGView addGestureRecognizer:tap];
    }
    return self;
}

+(void)showPopViewWithWindowOrigin:(CGPoint)origin dataSource:(NSArray *)dataSource icons:(NSArray *)icons action:(void (^)(NSInteger idx))action position:(TrianglePosition)position width:(CGFloat)width showSelect:(BOOL)showSel defaultIdx:(NSInteger)defaultIdx animation:(BOOL)animation
{
    // 初始化背景View
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    ZXPopView *popView = [[ZXPopView alloc] init];
    popView.position = position;
    popView.dataSource = dataSource;
    popView.icons = icons;
    popView.defaultIndex = defaultIdx;
    popView.showSelect = showSel;
    [window addSubview:popView];
    
    popView.action = action;
    
    popView.origin = origin;
    // TABLE表格初始化
    CGFloat tabW = WIDTH;
    if (width > 40) {
        tabW = width;
    }
    CGFloat rowHeight = ROW_HEIGHT;
    
    for (NSString *imageStr in icons)
    {
        if ([imageStr isEqualToString:@"sgm"])
        {
            tabW = 180;
        }
    }
    
    CGFloat tabH = dataSource.count*rowHeight;

    CGFloat X = origin.x - tabW;
    CGFloat Y = origin.y;
    
    CGFloat tabX;
    CGPoint thePoint;
    if (popView.position == TrianglePositionOfLeft) {
        tabX = X - tabW/2;
        thePoint = CGPointMake(0, 0);
    }else if (popView.position == TrianglePositionOfRight){
        tabX = X + tabW/2;
        thePoint = CGPointMake(1.0, 0);
    }else{
        tabX = X;
        thePoint = CGPointMake(0.5, 0);
    }
    
    BOOL needScroll = NO;
    if (dataSource.count > 10) {
        tabH = rowHeight * 10;
        needScroll = YES;
    }
    // anchorPoint默认是中心点（0.5，0.5）的位置
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(tabX, Y - tabH/2, tabW, tabH) style:UITableViewStylePlain];
    tableView.showsHorizontalScrollIndicator = needScroll;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = needScroll;
    tableView.dataSource = popView;
    tableView.delegate = popView;
    tableView.layer.cornerRadius = 8.0f;
    tableView.rowHeight = rowHeight;
    tableView.layer.anchorPoint = thePoint;
    tableView.transform =CGAffineTransformMakeScale(0.0001, 0.0001);
    [popView addSubview:tableView];
    popView.tableView = tableView;

    if (animation == YES)
    {
        popView.alpha = 0;
        popView.isAnimation = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            popView.alpha = 1;
            tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (finished) {
                popView.isAnimation = NO;
            }
        }];
    }
    else
    {
        popView.isAnimation = NO;
        popView.alpha = 1;
        tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}

-(void)hiden
{
    if (self.isAnimation) return; // 正在动画中
    
    if (self != nil) {
        self.isAnimation = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
            _tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
        } completion:^(BOOL finished) {
            if (finished) {
                self.isAnimation = NO;
                [self removeFromSuperview];
            }
        }];
    }
}


-(void)BGTapAction:(UIGestureRecognizer *)tap
{
    [self hiden];
}

#pragma mark UITableViewDatSource和UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"ZXPopView";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.tintColor = THEME_COLOR;
        cell.separatorInset = UIEdgeInsetsZero;
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
    // 是否显示选中状态
    if (self.showSelect && indexPath.row == self.defaultIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (self.icons.count >= self.dataSource.count)
    {
        UIImage *image = [UIImage imageNamed:self.icons[indexPath.row]];
        if (image)
        {
            cell.imageView.image = image;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    cell.textLabel.textColor = [UIColor grayColor];
    if (self.icons.count == 0)
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiden];
    self.action(indexPath.row);
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect
{
    CGFloat tabW = WIDTH;
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    CGContextRef  context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);
    CGFloat begin;  // 默认在右
    if (self.position == TrianglePositionOfLeft) // 左边
    {
        begin = self.origin.x - tabW + 30;
    }
    else if (self.position == TrianglePositionOfMiddle)  // 中间
    {
        begin = self.origin.x - tabW/2 + 10;
    }
    else
    {
        begin = self.origin.x - 10;
    }
    CGContextMoveToPoint(context,begin, self.origin.y);
    CGContextAddLineToPoint(context,begin - 7 ,self.origin.y - 10);
    CGContextAddLineToPoint(context,begin - 14, self.origin.y);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor whiteColor] setFill];  //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}



@end
