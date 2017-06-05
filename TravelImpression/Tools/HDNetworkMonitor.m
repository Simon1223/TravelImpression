//
//  HDNetworkMonitor.m
//  MobileInterconnect
//
//  Created by huadong on 2017/5/8.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import "HDNetworkMonitor.h"
#import "Reachability.h"
#import "AppDelegate.h"

@interface HDNetworkMonitor ()
{
    Reachability *reachability;
}
@end

@implementation HDNetworkMonitor

+(instancetype)shareMonitor
{
    static HDNetworkMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        monitor = [[HDNetworkMonitor alloc] init];
    });
    return monitor;
}

/**
 *  开启网络状态的监听
 */
- (void)startMonitorNetwork
{
    RegisterNotify(kReachabilityChangedNotification, @selector(reachabilityChanged:))
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    [AppDelegate delegate].networkStatus = reachability.currentReachabilityStatus;
}


- (void)reachabilityChanged:(NSNotification *)notice {
    
    NetworkStatus status = reachability.currentReachabilityStatus;
    switch (status) {
        case NotReachable:
//            BASE_INFO_FUN(@"无连接");
            NSLog(@"无连接");
            break;
        case ReachableViaWiFi:
//            BASE_INFO_FUN(@"WiFi连接");
            NSLog(@"WiFi连接");
            break;
        case ReachableViaWWAN:
//            BASE_INFO_FUN(@"数据网络");
            NSLog(@"数据网络");
            
            break;
        default:
            break;
    }
    
    [AppDelegate delegate].networkStatus = status;
}


- (BOOL)isWiFiEnable {
    
    return reachability.currentReachabilityStatus == ReachableViaWiFi;
}

- (BOOL)isNetworkEnable {
    
    return reachability.currentReachabilityStatus != NotReachable;
}


@end
