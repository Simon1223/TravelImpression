//
//  CustomNavigationController.h
//  ShenMaMall
//
//  Created by GPMacMini on 13-11-14.
//  Copyright (c) 2013年 GPMacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTRootNavigationController.h>

@interface HDNavigationController : RTRootNavigationController

#pragma mark 自定义返回按钮

- (UIBarButtonItem *)createBackButton;

- (void)backButtionCliecked;

@end
