//
//  SMTabBarController.h
//  ShenMaDiDiClient
//
//  Created by DiDi365 on 15/12/14.
//  Copyright © 2015年 HengTu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBarHeight(type) (type==HDTabBarTypeDefualt)?49:60

typedef NS_ENUM(NSInteger, HDTabBarType) {
    HDTabBarTypeDefualt = 0, //常规TabBar
    HDTabBarTypeCenter  = 1, //自定义中间大按钮TabBar
};


@interface HDTabBarController : UITabBarController

//!标签栏背景颜色
@property(nonatomic,strong)UIColor *tabBarBackgroundColor;

//!当前选中索引
@property(nonatomic,assign)NSInteger currentIndex;

//隐藏tarbar
@property(nonatomic,assign)BOOL hideTarBar;

//tabBar类型
@property (nonatomic, assign) HDTabBarType tabBarType;

- (instancetype)initWithType:(HDTabBarType)type;

@end
