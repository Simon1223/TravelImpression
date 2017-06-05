//
//  AppDelegate.m
//  TravelImpression
//
//  Created by Simon on 2017/6/5.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "AppDelegate.h"
#import "HDNetworkMonitor.h"
#import "iflyMSC/IFlyMSC.h"
#import <AddressBook/AddressBook.h>
#import "HDTabBarController.h"
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)delegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

/*
 * 网络监控
 */
- (void)netWorkMonitor
{
    //监听网络变化
    [[HDNetworkMonitor shareMonitor] startMonitorNetwork];
}

#pragma mark - network
- (void)setNetworkStatus:(NetworkStatus)networkStatus {
    if (_networkStatus != networkStatus) {
        _networkStatus = networkStatus;
        SendNotify(NETWORKSTATUSCHANGE, nil)
    }else {
        _networkStatus = networkStatus;
    }
}

/**
 * 科大讯飞授权初始化
 */
- (void)setUpiflyMSC
{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}



/**
 授权通讯录
 */
-(void)setAddressBook{
    //1. 获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //2. 创建 AddrssBook
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //3. 没有授权时就授权
    if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            //3.1 判断是否出错
            if (error) {
                return;
            }
            //3.2 判断是否授权
            if (granted) {
                NSLog(@"已经授权");
                
            } else {
                NSLog(@"没有授权");
            }
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        //读取通讯录人员数量
        
    } else {
        NSLog(@"拒绝授权");
    }
    CFRelease(addressBook);
}

- (void)setupLeanCouldWithOptions:(NSDictionary *)launchOptions
{
    //记录奔溃日志
    [AVOSCloudCrashReporting enable];
    
    //初始化LeanCould
    [AVOSCloud setApplicationId:LCAppID clientKey:LCAPPKey];
    
    //跟踪统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //开启调试日志，发布时关闭
    [AVOSCloud setAllLogsEnabled:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self netWorkMonitor];
    [self setAddressBook];
    [self setUpiflyMSC];
    [self setupLeanCouldWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    HDTabBarController *rootVC = [[HDTabBarController alloc] initWithType:HDTabBarTypeCenter];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
