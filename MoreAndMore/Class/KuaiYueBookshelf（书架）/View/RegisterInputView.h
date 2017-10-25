//
//  RegisterInputView.h
//  MoreAndMore
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterInputView : UIView

@property (weak, nonatomic) IBOutlet UITextField *txfRegisterName;
@property (weak, nonatomic) IBOutlet UITextField *txfRegisterAccount;
@property (weak, nonatomic) IBOutlet UITextField *txfRegisterPwd;

+(RegisterInputView *)registerView;

@end
