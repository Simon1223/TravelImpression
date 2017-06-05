//
//  AppDelegate.h
//  TravelImpression
//
//  Created by Simon on 2017/6/5.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/*
 * 网络状态
 */
@property (nonatomic, assign) NetworkStatus networkStatus;

/*
 * 获取app代理
 */
+ (AppDelegate *)delegate;

@end

