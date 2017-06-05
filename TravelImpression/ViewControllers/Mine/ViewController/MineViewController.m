//
//  MineViewController.m
//  Speech
//
//  Created by huadong on 2017/5/19.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "MineViewController.h"
#import "HDParallaxHeaderView.h"
#import "UserInfoView.h"
#import "MineCell.h"
#import "UserModel.h"
#import "HDNavigationController.h"

#define headerHeight 200

@interface MineViewController ()<UserInfoViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    HDParallaxHeaderView *headerView;
    UserInfoView *userInfoView;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.titleLabel.alpha = 0;
    
    [self setupRightButtonImage:@"message.png" space:15 action:@selector(messageAction)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self.navigationController.navigationBar.subviews[0] setAlpha:0];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.tableView registerClass:NSClassFromString(@"MineCell") forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    
    [self setupHeaderView];
}

- (void)setupHeaderView
{
    //添加列表头视图
    headerView = [[HDParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, headerHeight) animationDuration:0 openTimer:NO];
    headerView.enbleStretch = YES;
    
    headerView.isBlur = YES;
    headerView.blurLevel = 15;
    headerView.parallaxImageArray = @[[UIImage imageNamed:@"mine_banner.png"]];
    
    headerView.userInteractionEnabled = YES;
    [self.tableView setTableHeaderView:headerView];
}

- (void)setupUserInfoView
{
    if (userInfoView) {
        [userInfoView removeFromSuperview];
        userInfoView = nil;
    }
//    AVObject *object = [[UserModel query] getObjectWithId:[UserModel currentUser].objectId];
    userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, headerHeight) status:[UserModel currentUser]?1:0];
    userInfoView.delegate = self;
    [headerView addSubview:userInfoView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUserInfoView];
}

/**
 消息
 */
- (void)messageAction
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY;
    CGFloat offsetH;
    CGFloat alpha;
    if (scrollView == self.tableView)
    {
        offsetY = scrollView.contentOffset.y;
        offsetH = offsetY - 64;
        alpha = MIN(1, offsetH / 40);
        if (offsetY <= 0) {
            [headerView parallaxHeaderViewStretchingWithOffset:offsetY];
        }
        self.titleLabel.alpha = alpha;
        [self.navigationController.navigationBar.subviews[0] setAlpha:alpha];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ========== UserInfoViewDelegate ===========

/**
 UserInfoView按钮事件

 @param sender tag 10=登录 ， 1=旅行基金 ， 2=代金券 ， 3=订单
 */
- (void)userInfoViewButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 10:
        {
            HDBaseViewController *viewCtr = [[NSClassFromString(@"LoginViewController") alloc] init];
            HDNavigationController *nav = [[HDNavigationController alloc] initWithRootViewController:viewCtr];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark ========== UITableViewDelegate ===========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.titleLabel.text = @[@[@"我的行程",@"我的印象",@"我的收藏"],@[@"设置"]][indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //我的行程
                }
                    break;
                case 1:
                {
                    //我的印象
                }
                    break;
                case 2:
                {
                    //我的收藏
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            //设置
        }
            break;
        default:
            break;
    }
}

@end
