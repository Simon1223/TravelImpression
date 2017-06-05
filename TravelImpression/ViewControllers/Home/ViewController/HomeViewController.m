//
//  HomeViewController.m
//  Speech
//
//  Created by huadong on 2017/5/19.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "HomeViewController.h"
#import "SGPageView.h"

@interface NavigationBarTitleView : UIView

@end

@implementation NavigationBarTitleView

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)];
}

@end

@interface HomeViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegare>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    NSArray *childArr = @[@"AttentionViewController", @"FeaturedViewController", @"HotViewController"];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - 64 - 49;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"关注",@"精选",@"热门"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(50, 0, self.view.frame.size.width - 100, 44) delegate:self titleNames:titleArr];
    _pageTitleView.isShowIndicator = YES;
    _pageTitleView.isShowBottomSeparator = NO;
    _pageTitleView.isOpenTitleTextZoom = YES;
    _pageTitleView.indicatorColor = themeColor;
    _pageTitleView.indicatorHeight = 3;
    _pageTitleView.titleColorStateNormal = [UIColor grayColor];
    _pageTitleView.titleColorStateSelected = [UIColor whiteColor];
    _pageTitleView.selectedIndex = 1;
    NavigationBarTitleView *titleView = [[NavigationBarTitleView alloc] init];
    self.navigationItem.titleView = titleView;
    [titleView addSubview:_pageTitleView];
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
