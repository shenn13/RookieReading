//
//  RegisterInputView.m
//  MoreAndMore
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "RegisterInputView.h"

@interface RegisterInputView ()<UITextFieldDelegate>

@end

@implementation RegisterInputView

+(RegisterInputView *)registerView
{
    RegisterInputView *registerView = [[NSBundle mainBundle] loadNibNamed:@"RegisterInputView" owner:nil options:nil][0];
    
    registerView.backgroundColor = [UIColor clearColor];
    
    registerView.txfRegisterName.delegate = registerView;
    registerView.txfRegisterAccount.delegate = registerView;
    registerView.txfRegisterPwd.delegate = registerView;
    
    return registerView;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.txfRegisterName isFirstResponder])
    {
        [self.txfRegisterAccount becomeFirstResponder];
    }else if ([self.txfRegisterAccount isFirstResponder])
    {
        [self.txfRegisterPwd becomeFirstResponder];
    }
    [textField resignFirstResponder];
    
    return YES;
}

@end
