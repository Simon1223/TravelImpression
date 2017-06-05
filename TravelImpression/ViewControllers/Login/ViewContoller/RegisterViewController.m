//
//  RegisterViewController.m
//  Speech
//
//  Created by huadong on 2017/5/25.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UITextField *authField;
@property (nonatomic, weak) IBOutlet UIButton *authButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIButton *showPasswordButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    _authButton.enabled = NO;
    _registerButton.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 界面按钮事件
 这里采用验证码登录后设置密码
 @param sender tag 10=获取验证码 11=注册 12=显示密码
 */
- (IBAction)viewButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {
            [UserModel getAuthCodeWithPhone:_phoneField.text success:^(BOOL success) {
                if (success) {
                    //已发送验证码
                }
                else
                {
                    //验证码发送失败
                }
            }];
        }
            break;
        case 11:
        {
            //验证码登录
            [UserModel loginWithAccount:_phoneField.text verify:_authField.text success:^(UserModel *user) {
                //登录成功后设置登录密码
                [UserModel user:user setPassword:_passwordField.text success:^(BOOL success) {
                    if (success) {
                        //设置密码成功
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else
                    {
                        //设置密码失败
                    }
                }];
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case 12:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark ------- UITextFieldDelegate -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString:@""]) {
        [self textField:textField changeLoginButtonStatusWithReplacementString:string];
        return YES;
    }
    
    if(textField == _phoneField)
    {
        if(toBeString.length >11){
            return NO;
        }
        if ([PhoneNum rangeOfString:string].length<=0) {
            [self showOnlyText:@"请输入正确的手机号码"];
            return NO;
        }
        
        [self textField:textField changeLoginButtonStatusWithReplacementString:string];
    }
    else if(textField == _authField)
    {
        if(toBeString.length >6){
            return NO;
        }
        
        [self textField:textField changeLoginButtonStatusWithReplacementString:string];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark ------- 改变注册按钮和获取验证码按钮状态 -------
- (void)textField:(UITextField *)textField changeLoginButtonStatusWithReplacementString:(NSString *)string
{
    if (textField == _phoneField) {
        if ([string isEqualToString:@""]) {
            _authButton.enabled = NO;
            _registerButton.enabled = NO;
        }
        else
        {
            if (textField.text.length + string.length == 11){
                _authButton.enabled = YES;
                if (_authField.text.length >= 4 && _passwordField.text.length >= 6) {
                    _registerButton.enabled = YES;
                }
            }
            else
            {
                _authButton.enabled = NO;
            }
        }
    }
    else if (textField == _passwordField)
    {
        if ([string isEqualToString:@""]) {
            if (_passwordField.text.length <= 6) {
                _registerButton.enabled = NO;
            }
        }
        else
        {
            if (textField.text.length + string.length >= 6){
                if (_authField.text.length >= 4 && _phoneField.text.length == 11) {
                    _registerButton.enabled = YES;
                }
            }
            else
            {
                _registerButton.enabled = NO;
            }
        }
    }
    else if (textField == _authField)
    {
        if ([string isEqualToString:@""]) {
            if (_authField.text.length <= 4) {
                _registerButton.enabled = NO;
            }
        }
        else
        {
            if (textField.text.length + string.length >= 4){
                if (_passwordField.text.length >= 6 && _phoneField.text.length == 11) {
                    _registerButton.enabled = YES;
                }
                else
                {
                    _registerButton.enabled = NO;
                }
            }
            else
            {
                _registerButton.enabled = NO;
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
