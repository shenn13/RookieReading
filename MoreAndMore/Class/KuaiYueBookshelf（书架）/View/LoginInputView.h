//
//  LoginInputView.h
//  MoreAndMore
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginInputView : UIView

@property (weak, nonatomic) IBOutlet UITextField *txfLoginName;

@property (weak, nonatomic) IBOutlet UITextField *txfLoginPwd;

+(LoginInputView *)loginView;

@end
