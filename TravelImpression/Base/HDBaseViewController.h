//
//  HDBaseViewController.h
//
//  Created by SimonMBP on 14-6-3.
//  Copyright (c) 2014年 Simon All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LKBadgeView.h"
#import "SVProgressHUD.h"
#import "RTRootNavigationController.h"

#define PhoneNum @"1234567890"
#define PASSWORD @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

/**
 *  页面基类
 *  定义常用方法
 */

@interface HDBaseViewController : UIViewController

//@property(nonatomic, readonly, strong) LKBadgeView *messageBadgeView;

@property(nonatomic,copy) UILabel *titleLabel;
@property(nonatomic,copy) NSString *topTitle;
@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;

@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, assign)void(^resultBlock)(NSString *viewControllerName, id result);

#pragma mark - 公共方法

/**
 *  自定义返回按钮事件
 *
 */
- (void)setBackButtonAction:(SEL)action;
- (void)setBackButtonImage:(NSString *)imgName;
- (void)setBackButtonAction:(SEL)action WithImage:(NSString *)imgName
           highlightedImage:(NSString *)highlightedImage;

/**
 *  设置左边按钮
 *
 */
-(void)setupLeftButtonText:(NSString *)text
                 textColor:(UIColor *)textColor
                    action:(SEL)action;



-(void)setupLeftButtonImage:(NSString *)imgName
            highlightedImage:(NSString *)highlightedImage
                      action:(SEL)action;

-(void)setupLeftButtonImage:(NSString *)imgName
                      space:(CGFloat )space
                     action:(SEL)action;



- (void)setLeftButtonWithImage:(NSString *)imgName
                        action:(SEL)action;



/**
 *  设置右边按钮
 *
 */

-(void)setupRightButtonText:(NSString *)text
                  textColor:(UIColor *)textColor
                    action:(SEL)action;

-(void)setupRightButtonImage:(NSString *)imgName
            highlightedImage:(NSString *)highlightedImage
                      action:(SEL)action;

-(void)setupRightButtonImage:(NSString *)imgName
                       space:(CGFloat )space
                      action:(SEL)action;

-(void)setupRightButtonImage:(NSString *)imgName
            highlightedImage:(NSString *)highlightedImage
                       space:(CGFloat )space
                      action:(SEL)action;

- (void)setRightButtonWithImage:(NSString *)imgName
                         action:(SEL)action;


/**
 *  统一设置背景图片
 *
 */
-(void)setupBackgroundImage:(UIImage *)backgroundImage;

///**
// * 设置消息角标
// */
//-(void)setMessageBadgeValue:(NSInteger)value;

/**
 * 设置系统消息角标
 */
-(void)setSystemMessageBadgeValue;


#pragma mark - 显示自定义加载
- (void)showSMLoading;
- (void)showSMLoading:(CGFloat)top;
- (void)showSMLoading:(CGFloat)top onSuperView:(UIView *)superView;
- (void)showSMLoadingWithFrame:(CGRect)rect;
- (void)hideSMLoading;
- (void)hideSMLoadingNoTime;
- (void)showNoNetwork:(CGFloat)top;
- (void)showNoNetworkWithFrame:(CGRect)rect;
- (void)hideNoNetwork;


#pragma mark - HUD 相关方法
- (void)showLoadingWithText:(NSString *)text
                   maskType:(SVProgressHUDMaskType)maskType;
- (void)showLoading;
- (void)showLoadingWithText:(NSString *)text;

//页面不可点击
- (void)showClearLoading;
- (void)showClearLoadingWithText:(NSString *)text;

- (void)showOnlyText:(NSString *)text;
- (void)showInfoText:(NSString *)text;
- (void)showSuccessImageAndText:(NSString *)text;
- (void)showErrorImageAndText:(NSString *)text;
- (void)showImage:(NSString *)imgName text:(NSString *)text;

- (void)hideHUD;


- (void)backButtionCliecked;


#pragma mark - 解决UIScrollView滑动返回手势冲突
- (void)addScrollViewEdgePanGestureRecognizer:(UIScrollView *)target;




@end
