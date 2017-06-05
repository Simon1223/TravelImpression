//
//  HDBaseViewController.h
//
//  Created by SimonMBP on 14-6-3.
//  Copyright (c) 2014年 Simon All rights reserved.
//

#import "HDBaseViewController.h"

#define defualtTitleColor [UIColor whiteColor]

@interface HDBaseViewController ()<UIGestureRecognizerDelegate>


- (void)configureHUD;

@end

@implementation HDBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 200, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = defualtTitleColor;
        _titleLabel.font = Font(17);
        self.navigationItem.titleView = _titleLabel;
    }
    
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureHUD]; 
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view setExclusiveTouch:YES];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _leftButton = nil;
    _rightButton = nil;
}


#pragma mark - Private

/**
 初始化SVProgressHUD
 */
- (void)configureHUD{
    
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
}

#pragma mark - 公共方法

- (void)setSpaceButton:(UIButton *)button
                 space:(CGFloat)space
                  isLeft:(BOOL)isLeft
{
    
    button.frame = CGRectMake(0, 0, 44, 44);
    //解决按钮点击区域变大的bug
    UIView *nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, space)];
    UIBarButtonItem *nullItem = [[UIBarButtonItem alloc] initWithCustomView:nullView];
    NSArray *items = nil;
    if(![button titleForState:UIControlStateNormal].length)
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -space;
        items = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:button], nullItem];
        
        
    }else{
        
        items =@[[[UIBarButtonItem alloc] initWithCustomView:button], nullItem];
        
    }
    [button setExclusiveTouch:YES];
    
    if(isLeft){
        
        self.navigationItem.leftBarButtonItems = items;
    }
    else{
        self.navigationItem.rightBarButtonItems = items;
    }
}

/**
 *  创建按钮
 *
 */
- (UIButton *)careateButtonWithImage:(NSString *)imgName
                    highlightedImage:(NSString *)highlightedImage
                                text:(NSString *)text
                           textColor:(UIColor *)textColor
                              action:(SEL)action
{
    
    UIImage *image = [UIImage imageNamed:imgName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



/**
 *  自定义返回按钮事件
 *
 */
- (void)setBackButtonAction:(SEL)action{    
    
//    [GlobalTool sharedTool].backAction = action;
    UIButton *backButton = [self careateButtonWithImage:@"top_back.png" highlightedImage:@"" text:nil textColor:nil action:action];
    
    [self setSpaceButton:backButton space:20 isLeft:YES];
    self.leftButton = backButton;
    
}

- (void)setBackButtonImage:(NSString *)imgName{
    
    UIButton *backButton = [self careateButtonWithImage:imgName highlightedImage:@"" text:nil textColor:nil action:@selector(backButtionCliecked)];
    
    [self setSpaceButton:backButton space:20 isLeft:YES];
    self.leftButton = backButton;
}

- (void)setBackButtonAction:(SEL)action WithImage:(NSString *)imgName
           highlightedImage:(NSString *)highlightedImage{
    
//    [GlobalTool sharedTool].backAction = action;
    UIButton *backButton = [self careateButtonWithImage:imgName highlightedImage:highlightedImage text:nil textColor:nil action:action];
    [self setSpaceButton:backButton space:20 isLeft:YES];
    self.leftButton = backButton;
    
}


/**
 *  设置左边按钮
 *
 */
-(void)setupLeftButtonText:(NSString *)text
                 textColor:(UIColor *)textColor
                    action:(SEL)action{
    
    UIButton *button = [self careateButtonWithImage:nil highlightedImage:nil text:text textColor:textColor action:action];
    button.frame = CGRectMake(0.f, 0.f, 45.f, 30.f);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    button.showsTouchWhenHighlighted = YES;
    [self setSpaceButton:button space:20 isLeft:YES];
    self.leftButton = button;
}


-(void)setupLeftButtonImage:(NSString *)imgName
           highlightedImage:(NSString *)highlightedImage
                     action:(SEL)action{
    
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:highlightedImage text:nil textColor:nil action:action];
    
    [self setSpaceButton:button space:20 isLeft:YES];
    self.leftButton = button;
    
}

-(void)setupLeftButtonImage:(NSString *)imgName
                      space:(CGFloat )space
                     action:(SEL)action
{
    
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:@"" text:nil textColor:nil action:action];
    
    [self setSpaceButton:button space:space isLeft:YES];
    self.leftButton = button;
    
}



/**
 *  设置右边按钮
 *
 */

-(void)setupRightButtonText:(NSString *)text
                  textColor:(UIColor *)textColor
                     action:(SEL)action{
    
    
    UIButton *button = [self careateButtonWithImage:nil highlightedImage:nil text:text textColor:textColor action:action];
    button.frame = CGRectMake(0.f, 0.f, 45.f, 30.f);
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    button.showsTouchWhenHighlighted = YES;
    
    [self setSpaceButton:button space:20 isLeft:NO];
    self.rightButton = button;
}

-(void)setupRightButtonImage:(NSString *)imgName
            highlightedImage:(NSString *)highlightedImage
                      action:(SEL)action{
    
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:highlightedImage text:nil textColor:nil action:action];
    
    [self setSpaceButton:button space:20 isLeft:NO];
    self.rightButton = button;
    
}

-(void)setupRightButtonImage:(NSString *)imgName
                      space:(CGFloat )space
                     action:(SEL)action
{
    
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:@"" text:nil textColor:nil action:action];

    [self setSpaceButton:button space:space isLeft:NO];
    self.rightButton = button;
}

-(void)setupRightButtonImage:(NSString *)imgName
            highlightedImage:(NSString *)highlightedImage
                       space:(CGFloat )space
                      action:(SEL)action
{
    
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:highlightedImage text:nil textColor:nil action:action];
    
    [self setSpaceButton:button space:space isLeft:NO];
    self.rightButton = button;
}

- (void)setLeftButtonWithImage:(NSString *)imgName
                        action:(SEL)action
{
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:nil text:nil textColor:nil action:action];
    
//    [button addSubview:self.unReadOrderImg];
    self.leftButton = button;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setRightButtonWithImage:(NSString *)imgName
                         action:(SEL)action
{
    UIButton *button = [self careateButtonWithImage:imgName highlightedImage:nil text:nil textColor:nil action:action];
    self.rightButton = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}



/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage{
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}


/**
 * 设置系统消息角标
 */
-(void)setSystemMessageBadgeValue{
    
//    NSInteger badgeValue = 0;
//    if(LOGIN_USERID){
//        
////        badgeValue = [MessageSessionModel badgeValueSystemMessageForLoginId:LOGIN_USERID];
//    }
//    [self setMessageBadgeValue:badgeValue];
}

-(void)backButtionCliecked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HUD 相关方法

- (void)showLoadingWithText:(NSString *)text
                   maskType:(SVProgressHUDMaskType)maskType
{
    
    [SVProgressHUD setDefaultMaskType:maskType];
    [SVProgressHUD showWithStatus:text];
}

- (void)showLoading{
    
    [SVProgressHUD show];
}

- (void)showLoadingWithText:(NSString *)text{
    
    [SVProgressHUD showWithStatus:text];
}


- (void)showClearLoading{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}
- (void)showClearLoadingWithText:(NSString *)text{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:text];
}

- (void)showOnlyText:(NSString *)text{
    
    [SVProgressHUD showImage:nil status:text];
}
- (void)showInfoText:(NSString *)text{
    
    [SVProgressHUD showInfoWithStatus:text];
}

- (void)showSuccessImageAndText:(NSString *)text{
    
    [SVProgressHUD showSuccessWithStatus:text];
}
- (void)showErrorImageAndText:(NSString *)text{
    
    [SVProgressHUD showErrorWithStatus:text];
}
- (void)showImage:(NSString *)imgName text:(NSString *)text{
    
    [SVProgressHUD showImage:[UIImage imageNamed:imgName] status:text];
}


- (void)hideHUD{
    [SVProgressHUD dismiss];
}

#pragma mark - 解决UIScrollView滑动返回手势冲突
- (void)addScrollViewEdgePanGestureRecognizer:(UIScrollView *)target{
    
    UIGestureRecognizer *screenEdgePanGestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
    [target.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return self.navigationController.viewControllers.count > 1;
}


@end
