//
//  LibraryMenuItemCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "LibraryMenuItemCell.h"

@interface LibraryMenuItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showIcon;

@property (weak, nonatomic) IBOutlet UILabel *showTitle;

@end

@implementation LibraryMenuItemCell

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setMenuModel:(TextMenuModel *)menuModel
{
    _menuModel = menuModel;
    
    UIImage *showImage = [UIImage imageNamed:menuModel.name] ? [UIImage imageNamed:menuModel.name] : DEFAULT_BG;
    
    [self.showIcon setImage:showImage];
    
    self.showTitle.text = menuModel.name;
}

@end
