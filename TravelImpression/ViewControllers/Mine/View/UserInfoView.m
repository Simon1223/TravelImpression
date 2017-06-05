//
//  UserInfoView.m
//  Speech
//
//  Created by Simon on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "UserInfoView.h"

@interface UserInfoView ()


/**
 用户是否登录
 */
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;

@end

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame status:(NSInteger)status
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:status];
        self.status = status;
        [self setupUserInfoView];
    }
    
    self.frame = frame;
    
    return self;
}

- (void)setupUserInfoView
{
    [self.userImageView borderWithRadius:40 color:[UIColor colorWithWhite:0.8 alpha:0.2] width:0.5];
    if (self.status == 0) {
        //未登录
        [self.loginButton borderWithRadius:18 color:[UIColor clearColor] width:0];
    }
    else
    {
        
    }
}

/**
 头部按钮事件

 @param sender tag : 10=登录 ， 1=旅行基金 ，2=代金券 ， 3=订单
 */
- (IBAction)headerButtonAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(userInfoViewButtonAction:)]) {
        [_delegate userInfoViewButtonAction:sender];
    }
}

@end
