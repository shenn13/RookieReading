//
//  BookSelectHeader.m
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSelectHeader.h"

@interface BookSelectHeader ()

@property (weak, nonatomic) IBOutlet UIButton *btnProduct;

@property (weak, nonatomic) IBOutlet UIButton *btnContent;

// 中间竖线
@property (weak, nonatomic) IBOutlet UIImageView *lineOne;
// 底部横线
@property (nonatomic,strong) UIImageView *verLine;

@end

@implementation BookSelectHeader

- (void)awakeFromNib
{
    self.lineOne.width = 0.5f;
    
    [self.btnProduct setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnProduct setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [self.btnContent setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [self addSubview:self.verLine];
    
    [self configShowProduct:NO];
}

-(void)configShowProduct:(BOOL)show
{
    self.btnProduct.selected = show;
    self.btnContent.selected = !show;
    
    CGFloat offset_x = SCREEN_WIDTH/2;
    if (show) {
        offset_x = 0.f;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.verLine.originX = offset_x;
    }];
    
    if ([self.deleagate respondsToSelector:@selector(didClickShowProduct:)])
    {
        [self.deleagate didClickShowProduct:show];
    }
}

-(UIImageView *)verLine
{
    if (!_verLine) {
        _verLine = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, self.btnProduct.height - 2, SCREEN_WIDTH/2, 1)];
        _verLine.backgroundColor = THEME_COLOR;
    }
    return _verLine;
}

- (IBAction)btnProductClick:(UIButton *)sender
{
    [self configShowProduct:YES];
}

- (IBAction)btnContentClick:(UIButton *)sender
{
    [self configShowProduct:NO];
}

@end
