//
//  CustomNavigationController.m
//  ShenMaDriving
//
//  Created by GPMacMini on 13-11-14.
//  Copyright (c) 2013年 GPMacMini. All rights reserved.
//

#import "HDNavigationController.h"
#import "HDBaseViewController.h"
#import "HDTabBarController.h"

@interface HDNavigationController ()<UINavigationControllerDelegate>

@end
@implementation HDNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

+ (void)initialize {
    // 设置导航items数据主题
    [self setupNavigationItemsTheme];
    
    // 设置导航栏主题
    [self setupNavigationBarTheme];
}

#pragma mark -  设置导航items数据主题
+ (void)setupNavigationItemsTheme {
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    // 设置字体颜色
    //    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateHighlighted];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateDisabled];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
}


#pragma mark -  设置导航栏主题
+ (void)setupNavigationBarTheme {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    // 设置导航栏title属性
    // [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // 设置导航栏颜色
//    [navigationBar setBarTintColor:[UIColor redColor]];
    
    // 设置导航栏图片
     [navigationBar setBackgroundImage:[UIImage imageWithColor:RGB(35, 48, 55, 1)] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 自定义返回按钮

- (UIBarButtonItem *)createBackButton
{
    UIImage* image= [UIImage imageNamed:@"back.png"];
//    UIImage* imagef = [UIImage imageNamed:@"return_btn_td.png"];
    CGRect backframe= CGRectMake(0, 0, 44, 44);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtionCliecked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backItem;
}


#pragma mark - Action

-(void)backButtionCliecked
{
    [SVProgressHUD dismiss];
    [self popViewControllerAnimated:YES];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] >=1)
    {        
      
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -20;
        UIView *nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem *nullItem = [[UIBarButtonItem alloc] initWithCustomView:nullView];
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, [self createBackButton],nullItem];

    }
 
    [super pushViewController:viewController animated:animated];
}




@end
