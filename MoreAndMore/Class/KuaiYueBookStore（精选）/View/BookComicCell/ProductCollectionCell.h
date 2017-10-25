//
//  ProductCollectionCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labDescrip;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *lanName;


+(CGFloat)productHeight;

@end
