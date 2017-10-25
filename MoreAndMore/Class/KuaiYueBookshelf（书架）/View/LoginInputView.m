//
//  LoginInputView.m
//  MoreAndMore
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "LoginInputView.h"

@interface LoginInputView ()<UITextFieldDelegate>

@end

@implementation LoginInputView

+(LoginInputView *)loginView
{
    LoginInputView *loginView = [[NSBundle mainBundle] loadNibNamed:@"LoginInputView" owner:nil options:nil][0];
    
    loginView.backgroundColor = [UIColor clearColor];
    
    loginView.txfLoginName.delegate = loginView;
    loginView.txfLoginPwd.delegate = loginView;
    
    return loginView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.txfLoginName isFirstResponder])
    {
        [self.txfLoginPwd becomeFirstResponder];
    }
    [textField resignFirstResponder];
    
    return YES;
}

@end
