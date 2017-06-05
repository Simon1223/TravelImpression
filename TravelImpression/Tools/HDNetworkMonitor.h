//
//  HDNetworkMonitor.h
//  MobileInterconnect
//
//  Created by huadong on 2017/5/8.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import <Foundation/Foundation.h>

/**网络监控**/
@interface HDNetworkMonitor : NSObject

+ (instancetype)shareMonitor;

/**
 *  开启网络状态的监听
 */
- (void)startMonitorNetwork;

- (BOOL)isWiFiEnable;

- (BOOL)isNetworkEnable;

@end
