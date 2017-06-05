//
//  FeaturedDetailViewController.m
//  Speech
//
//  Created by huadong on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "FeaturedDetailViewController.h"

@interface FeaturedDetailViewController ()

@end

@implementation FeaturedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"------id=%@",self.params[@"id"]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.resultBlock) {
        self.resultBlock(NSStringFromClass([self class]), @"111111");
    }
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
