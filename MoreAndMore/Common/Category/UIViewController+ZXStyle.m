//
//  UIViewController+ZXStyle.m
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "UIViewController+ZXStyle.h"

@implementation UIViewController (ZXStyle)

#pragma mark 导航栏BarItem配置
+(UIBarButtonItem *)getNegativeSpacer:(CGFloat)offSet
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = offSet;
    return negativeSpacer;
}

+(UIBarButtonItem *)barItemWithTarget:(id)target action:(SEL)action tag:(NSInteger)tag norTitle:(NSString *)norTitle selTitle:(NSString *)selTitle imageName:(NSString *)imageName selImageName:(NSString *)selImageName
{
    if ([NSString checkEmpty:norTitle] && [NSString checkEmpty:imageName]) return nil;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat btnWH = 0;
    if (![NSString checkEmpty:imageName])
    {
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *selImage = [UIImage imageNamed:selImageName];
        
        [btn setImage:image forState:UIControlStateNormal];
        if (selImage == nil)
        {
            selImage = image;
        }
        [btn setImage:selImage forState:UIControlStateSelected];
        
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat max = MAX(image.size.width, image.size.height);
        btnWH = max > 30 ? 30 : max;
    }
    
    CGFloat textW = 0;
    if (![NSString checkEmpty:norTitle])
    {
        // 标题字体
        btn.titleLabel.font = FONT(ITEM_FONTSIZE);
        // 文字颜色
        [btn setTitleColor:THEME_TINTCOLOR forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        
        [btn setTitle:norTitle forState:UIControlStateNormal];
        if ([NSString checkEmpty:selTitle])
        {
            selTitle = norTitle;
        }
        [btn setTitle:selTitle forState:UIControlStateSelected];
  
        CGSize textSize = [norTitle stringWidthWithFontSize:ITEM_FONTSIZE andHeight:30];
        textW += textSize.width + 4;
    }
    
    btnWH = MIN(25.f, btnWH);
    
    btn.frame = CGRectMake(0, 0, btnWH + textW, btnWH);
    
    // 绑定button点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 绑定button tag值
    btn.tag =  ITEM_TAG + tag;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];

    return item;
}

-(void)barItemWithPosition:(BarItemPosition)position isImage:(BOOL)isImage spacer:(CGFloat)spacer norArr:(NSArray *)norArr selArr:(NSArray *)selArr
{
    if (norArr.count < 1)
    {
        return;
    }
    
    SEL action = (position == BarItemPositionOfLeft) ? @selector(leftBarItemClick:) : @selector(rightBarItemClick:);
    
    NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < norArr.count; i++)
    {
        NSString *norValue = norArr[i];
        NSString *selValue = norValue ;
        if (selArr.count > 0 && selArr.count == norArr.count)
        {
            selValue = selArr[i];
        }
        UIBarButtonItem *item ;
        if (isImage)
        {
            item = [UIViewController barItemWithTarget:self action:action tag:i norTitle:nil selTitle:nil imageName:norValue selImageName:selValue];
        }
        else
        {
            item = [UIViewController barItemWithTarget:self action:action tag:i norTitle:norValue selTitle:selValue imageName:nil selImageName:nil ];
        }
        
        [itemArr addObject:item];
        
        if (norArr.count > 1)
        {
            // 让多个item之间间隔大一点
            item.customView.width += spacer;
        }
    }
    
    /*
    UIBarButtonItem *spacer = [UIViewController getNegativeSpacer:-10];
    [itemArr insertObject:spacer atIndex:0];
     */
    
    if (position == BarItemPositionOfLeft) {
        self.navigationItem.leftBarButtonItems = itemArr;
    }else{
        self.navigationItem.rightBarButtonItems = itemArr;
    }
}

#pragma mark 导航栏按钮点击事件
-(void)leftBarItemClick:(UIButton *)leftItem
{
    NSLog(@"点击了左边第%ld按钮，items:%@",leftItem.tag - ITEM_TAG + 1,self.navigationItem.leftBarButtonItems);
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    NSLog(@"点击了右边第%ld按钮，items:%@",rightItem.tag - ITEM_TAG + 1,self.navigationItem.rightBarButtonItems);
}

-(void)dismissOrPopBack
{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}


@end
