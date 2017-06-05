//
//  SMTabBarController.m
//  ShenMaDiDiClient
//
//  Created by DiDi365 on 15/12/14.
//  Copyright © 2015年 HengTu. All rights reserved.
//

#import "HDTabBarController.h"
#import "HDNavigationController.h"
#import "SVProgressHUD.h"
#import "HDTabBar.h"

#define tabBarDefaultTag 10000

@interface HDTabBarController ()<HDTabBarDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong)HDTabBar *hd_tabBar;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *images;
@property (nonatomic, strong)NSArray *selectedImages;
@property (nonatomic, strong)NSArray *itemControllers;
@property (nonatomic, strong) NSMutableArray *items;

@end


@implementation HDTabBarController

- (instancetype)initWithType:(HDTabBarType)type
{
    _tabBarType = type;
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];

    _titles = @[@"首页",@"发现",@"购买",@"我的"];
    _images = @[@"tabbar_home",@"tabbar_find",@"tabbar_news",@"tabbar_mine"];
    _selectedImages = @[@"tabbar_home_td",@"tabbar_find_td",@"tabbar_news_td",@"tabbar_mine_td"];
    _itemControllers = @[@"HomeViewController",@"FindViewController",@"BuyViewController",@"MineViewController"];
    
    if (_tabBarType == HDTabBarTypeDefualt) {
        [self setupDefualtTabBar];
    }
    else if (_tabBarType == HDTabBarTypeCenter)
    {
        _items = [NSMutableArray new];
        [self setupCenterTabBar];
    }
}


- (void)setupItemWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage viewController:(NSString *)viewControllerString
{
    NSAssert(viewControllerString, @"viewController为空");
    UITabBarItem *item = [[UITabBarItem alloc] init];
    [item setTitle:title];
    [item setImage:[UIImage imageNamed:image]];
    [item setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:itemColor}
                        forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:itemSelectedColor}
                         forState:UIControlStateSelected];
    
    UIViewController *ctr = [[NSClassFromString(viewControllerString) alloc] init];
    HDNavigationController *nav = [[HDNavigationController alloc] initWithRootViewController:ctr];
    nav.tabBarItem = item;
    [self addChildViewController:nav];
    
    if (_tabBarType == HDTabBarTypeCenter) {
        [_items addObject:item];
    }
}

/**
 默认TabBar
 */
- (void)setupDefualtTabBar
{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_back"];
    for (int i = 0; i<_titles.count; i++) {
        [self setupItemWithTitle:_titles[i] image:_images[i] selectedImage:_selectedImages[i] viewController:_itemControllers[i]];
    }
    self.delegate = self;
    self.selectedIndex = 0;
}

/**
 中间特殊化TabBar
 */
- (void)setupCenterTabBar
{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_back"];
    for (int i = 0; i<_titles.count; i++) {
        [self setupItemWithTitle:_titles[i] image:_images[i] selectedImage:_selectedImages[i] viewController:_itemControllers[i]];
    }
    
    _hd_tabBar = [[HDTabBar alloc] init];
    _hd_tabBar.HDTabBardelegate = self;
    _hd_tabBar.delegate = self;
    _hd_tabBar.items = _items;
    [self setValue:_hd_tabBar forKey:@"tabBar"];
    self.delegate = self;
    self.selectedIndex = 0;
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    [SVProgressHUD dismiss];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (_tabBarType == HDTabBarTypeCenter) {
        [_hd_tabBar closeCenterButton];
    }
    
    //点击tabBarItem动画
    if (self.selectedIndex != _currentIndex)
    {
        [self tabBarButtonClick:[self getTabBarButton]];
    }
}

- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}


- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
    _currentIndex = self.selectedIndex;
}

#pragma mark ------HDTabBarDelegate
- (void)centerButtonClick:(UIButton *)sender
{
    
}

@end
