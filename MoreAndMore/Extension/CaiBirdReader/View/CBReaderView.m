//
//  CBReaderView.m
//  MoreAndMore
//
//  Created by apple on 2017/2/27.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBReaderView.h"
#import <CoreText/CoreText.h>
#import "CBReaderStyle.h"

@interface CBReaderView()
{
    CTFrameRef _ctFrame;
}

@property (nonatomic,weak)UIFont *textFont;

@end

@implementation CBReaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat wComponent = frame.size.width/3;
        CGFloat height = frame.size.height;
        // 重点手势区域
        UIView *middleTapView = [[UIView alloc] init];
        middleTapView.backgroundColor = [UIColor clearColor];
        [self addSubview:middleTapView];
        [middleTapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(wComponent, height));
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        // 添加单击手势
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readerViewTapAction:)];
        [middleTapView addGestureRecognizer:tapRecognizer];
        
        self.text = @"";
    }
    return self;
}

+(CGRect)textContentRect
{
    CGFloat horMar = 20.f;
    CGFloat verMar = 30.f;
    return CGRectMake(horMar, verMar, [UIScreen mainScreen].bounds.size.width - horMar * 2, [UIScreen mainScreen].bounds.size.height - verMar * 2);
}

- (void)dealloc
{
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
    }
}

-(void)setText:(NSString *)text
{
    _text = text;

    if (text.length < 1) {
        return;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString setAttributes:[CBReaderStyle coreTextAttributes] range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame), _ctFrame = NULL;
    }
    _ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);

    CFRelease(path);
    CFRelease(frameSetter);
}

-(UIFont *)textFont {
    return [[CBReaderStyle shareStyle] font];
}

#pragma mark - 绘制

- (void)drawRect:(CGRect)rect
{
    if (!_ctFrame) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform transform = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    
    CTFrameDraw(_ctFrame, context);
}

#pragma mark - 单击手势

-(void)readerViewTapAction:(UITapGestureRecognizer *)tap
{
    // 单击手势
    if (self.ReaderViewTapAction) {
        self.ReaderViewTapAction();
    }
}


@end
