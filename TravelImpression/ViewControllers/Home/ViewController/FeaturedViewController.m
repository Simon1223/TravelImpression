//
//  FeaturedViewController.m
//  Speech
//
//  Created by huadong on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "FeaturedViewController.h"
#import "FeaturedCell.h"

@interface FeaturedViewController ()

@end

@implementation FeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [self setupFooterView];
    self.tableView.tableHeaderView = [self setupHeaderView];
}

- (UIView *)setupHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    headerView.backgroundColor = [UIColor orangeColor];
    
    return headerView;
}

- (UIView *)setupFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    FeaturedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FeaturedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier model:nil];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        HDTableViewController *viewCTR = [[NSClassFromString(@"FeaturedDetailViewController") alloc] init];
        viewCTR.params = @{@"id":[NSString stringWithFormat:@"%ld",indexPath.row]};
        viewCTR.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewCTR animated:YES];
        [viewCTR setResultBlock:^(NSString *name , id result){
            NSLog(@"---------%@",name);
        }];
    });
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
