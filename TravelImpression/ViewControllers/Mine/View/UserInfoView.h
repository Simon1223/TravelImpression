//
//  UserInfoView.h
//  Speech
//
//  Created by Simon on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoViewDelegate <NSObject>

- (void)userInfoViewButtonAction:(UIButton *)sender;

@end

/**
 我的主页表头
 */
@interface UserInfoView : UIView

@property (nonatomic, assign) id<UserInfoViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame status:(NSInteger)status;

@end
