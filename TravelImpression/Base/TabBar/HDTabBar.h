//
//  HDTabBar.h
//  Speech
//
//  Created by huadong on 2017/5/18.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDTabBarDelegate <NSObject>

- (void)centerButtonClick:(UIButton *)sender;

@end

/**
 自定义TabBar
 */
@interface HDTabBar : UITabBar

@property (nonatomic, strong) id<HDTabBarDelegate>HDTabBardelegate;

- (void)closeCenterButton;


@end
