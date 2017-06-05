//
//  LoginWithAccountViewController.m
//  Speech
//
//  Created by huadong on 2017/5/25.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "LoginWithAccountViewController.h"

@interface LoginWithAccountViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UIView *inputView;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *backHeight;

@end

@implementation LoginWithAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.backHeight.constant = DEVICE_HEIGHT;
    self.loginButton.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 登录界面按钮事件
 
 @param sender tag 登录=10, 切换账号=11, 忘记密码=12
 */
- (IBAction)viewButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {
            //登录
            
        }
            break;
        case 11:
        {
            //切换账号
            
        }
            break;
        case 12:
        {
            //忘记密码
            
        }
            break;
        default:
            break;
    }
}

/**
 登录失败,抖动提示
 */
- (void)loginFail
{
    CALayer *viewLayer = self.inputView.layer;
    CGPoint position = viewLayer.position;
    CGPoint right = CGPointMake(position.x + 1, position.y);
    CGPoint left = CGPointMake(position.x - 1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:right]];
    [animation setToValue:[NSValue valueWithCGPoint:left]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.1];
    [animation setRepeatCount:4];
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark ------- UITextFieldDelegate -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if(textField == _passwordField)
    {
        if(toBeString.length >16){
            return NO;
        }
        
        [self changeLoginButtonStatus];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark ------- 改变登录按钮状态 -------
- (void)changeLoginButtonStatus
{
    if (_passwordField.text.length>=6) {
        _loginButton.enabled = YES;
    }
    else
    {
        _loginButton.enabled = NO;
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
