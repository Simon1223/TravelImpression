//
//  LoginViewController.m
//  Speech
//
//  Created by huadong on 2017/5/25.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UIView *inputView;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomSpace;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    CGFloat height = DEVICE_HEIGHT - 64 - 382 - 133;
    if (height>0) {
        self.bottomSpace.constant = height;
    }
    else
    {
        self.bottomSpace.constant = 0;
    }

    [self setupLeftButtonImage:@"back.png" space:15 action:@selector(cancelLogin)];
    
    self.loginButton.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)cancelLogin
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 登录界面按钮事件

 @param sender tag 登录=10, 注册=11, 忘记密码=12, 微信=1, QQ=2, 微博=3
 */
- (IBAction)viewButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1 | 2 | 3:
        {
            //第三方登录
            
        }
            break;
        case 10:
        {
            //登录
            [UserModel loginWithAccount:_phoneField.text pass:_passwordField.text success:^(UserModel *user) {
                [self dismissViewControllerAnimated:YES completion:nil];
                
                
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case 11:
        {
            //注册
            HDBaseViewController *viewCtr = [[NSClassFromString(@"RegisterViewController") alloc] init];
            [self.navigationController pushViewController:viewCtr animated:YES];
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
    
    if(textField == _phoneField)
    {
        if(toBeString.length >11){
            return NO;
        }
        if ([PhoneNum rangeOfString:string].length<=0) {
            [self showOnlyText:@"请输入正确的手机号码"];
            return NO;
        }
        
        [self changeLoginButtonStatus];
    }
    else if(textField == _passwordField)
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
    if ((_phoneField.text.length == 11) && (_passwordField.text.length>=6)) {
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



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
