//
//  CollectionHeaderReusableView.m
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "CollectionHeaderReusableView.h"
#import "StoreListModel.h"
#import "FXBlurView.h"

@interface CollectionHeaderReusableView ()

@property (nonatomic, strong) UIImage *contentShowImage;
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@property (nonatomic, assign)BOOL isTitleCenter;

@end

@implementation CollectionHeaderReusableView


- (void)awakeFromNib
{
    [super awakeFromNib];
    // 返回按钮
    self.backButton.imageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.backButton.imageView.layer.cornerRadius = 22.f;
    self.backButton.imageView.layer.masksToBounds = YES;
    // 标题
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.titleLabel.height = self.titleContentView.height;
    // 背景图、背景遮罩层
    self.contentImageView.layer.zPosition = -2;
    self.maskImageView.layer.zPosition = -1;
    
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.maskImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addGradient];
}

#pragma mark - 收藏和取消收藏

- (IBAction)collectAction:(UIButton *)sender
{
    LOGINNEED_ACTION
    
    kSelfWeak;
    [self.book topicCollectBookComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.book.is_favourite = !weakSelf.book.is_favourite;
            
            NSString *imageIcon = self.book.is_favourite ? @"ratingStar_full" : @"ratingStar_empty";
            [self.btnCollect setImage:[UIImage imageNamed:imageIcon] forState:UIControlStateNormal];
            
            NSString *message = weakSelf.book.is_favourite ? @"收藏成功!" : @"取消收藏成功!";
            
            [self showText:message inView:WINDOW];
            
            if (!weakSelf.book.idd) return ;
            
            // 刷新书籍（如果需要)
            [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_BOOK_REFRESH object:nil userInfo:@{IMAGE_BOOK_ID:weakSelf.book.idd}];
        }
    }];
}

#pragma mark - 排序
- (IBAction)sortClickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.book.order = sender.selected;

    if ([self.delegate respondsToSelector:@selector(clickSortActionWithStatus:)])
    {
        [self.delegate clickSortActionWithStatus:sender.selected];
    }
}

// 标题渐变遮罩层
- (void)addGradient
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.titleContentView.bounds;
    gradientLayer.zPosition = -1;
    UIColor *graidentColor = [UIColor blackColor];
    gradientLayer.locations = @[@0];
    gradientLayer.colors = @[(__bridge id)[graidentColor colorWithAlphaComponent:0.8].CGColor,
                             (__bridge id)[graidentColor colorWithAlphaComponent:0.0].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 1);
    gradientLayer.endPoint = CGPointMake(0.5, 0);
    [self.titleContentView.layer addSublayer:gradientLayer];
    _gradientLayer = gradientLayer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.maskValue = MAX(self.imageHeight - self.height, 0)/ self.imageHeight;
    CGFloat maskValue = MAX(self.imageHeight - (self.height - 64), 0)/ self.imageHeight;
    self.backButton.imageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5 * (1 - maskValue)];
    
    [CATransaction begin];
    //去除隐性动画
    [CATransaction setDisableActions:YES];
    self.gradientLayer.opacity = (1 - maskValue);
    [CATransaction commit];
    
    CGFloat title_X = 0.0;
    BOOL isTitleCenter;
    if (self.titleContentView.originY > 44) {
        title_X = 10;
        isTitleCenter = NO;
    }else{
        title_X = (self.width - self.titleLabel.width)/ 2;
        isTitleCenter = YES;
    }
  
    if (!isTitleCenter == self.isTitleCenter) {
        self.isTitleCenter = isTitleCenter;
        [UIView animateWithDuration:0.25 animations:^{
            self.titleLabel.originX = title_X;
            self.btnSort.hidden = isTitleCenter;
        }];
    }
    
}

-(void)setBook:(Topic *)book
{
    _book = book;
    // 图片相关
    [self settingContentImageForURLString];
    
    self.titleLabel.text = book.title;
    self.titleLabel.width = [book.title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width;
    
    CGFloat title_X = 0.0;
    if (!self.isTitleCenter) {
        title_X = 10;
    }else{
        title_X = (self.width - self.titleLabel.width)/ 2;
    }
    self.titleLabel.originX = title_X;
    
    NSString *imageIcon = self.book.is_favourite ? @"ratingStar_full" : @"ratingStar_empty";
    [self.btnCollect setImage:[UIImage imageNamed:imageIcon] forState:UIControlStateNormal];
    
    self.btnSort.selected = self.book.order;
}

- (void)setContentShowImage:(UIImage *)contentShowImage
{
    _contentShowImage = contentShowImage;
    
    self.maskImageView.image = [self.contentShowImage
                                blurredImageWithRadius:10
                                iterations:5
                                tintColor:[UIColor blackColor]];
}

- (void)setMaskValue:(CGFloat)maskValue
{
    _maskValue = maskValue;
    
    if (!self.contentShowImage) return;
    
    self.maskImageView.alpha = MIN(maskValue * 2, 1);
}

- (void)settingContentImageForURLString
{
    NSString *picStr = _book.cover_image_url;
    if (_book.pic.length > 0) {
        picStr = _book.pic;
    }
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:picStr]
                             placeholderImage:nil
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (image)
         {
             self.contentShowImage = image;
             /*
             CGFloat imageHeight = (image.size.height * (self.width/ image.size.width));
             //图片高度可能会不等于原始imageView高度，做处理
             if (imageHeight != self.imageHeight)
             {
                 for (NSLayoutConstraint *layout in self.constraints)
                 {
                     if ([layout.identifier isEqualToString:@"imageBottomLayout"])
                     {
                         layout.constant = -(imageHeight - self.imageHeight);
                     }
                 }
             }
            */
         }
     }];
}

#pragma mark - action
- (IBAction)backButtonAction:(id)sender
{
    [JUMP_MANAGER.jumpNavigation popViewControllerAnimated:YES];
}


@end
