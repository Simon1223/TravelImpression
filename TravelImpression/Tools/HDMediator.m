//
//  HDMediator.m
//  Speech
//
//  Created by Simon on 2017/5/22.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "HDMediator.h"

@interface HDMediator ()

@end

@implementation HDMediator

+ (HDMediator *)sharedInstace
{
    static HDMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HDMediator alloc] init];
        
    });
    return mediator;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary new];
    }
    
    return _params;
}

- (void)start:(NSString *)startViewController destination:(NSString *)destinationViewController params:(NSDictionary *)params
{
    [self.params setObject:params forKey:destinationViewController];
    UIViewController *startCTR = [[NSClassFromString(startViewController) alloc] init];
    UIViewController *destination = [[NSClassFromString(destinationViewController) alloc] init];
    [startCTR.navigationController pushViewController:destination animated:YES];
    
}

- (void)destination:(NSString *)destinationViewController Return:(ResultBlock)result
{
    if ([self.params objectForKey:destinationViewController]) {
        self.resultBlock = result;
        [self.params removeObjectForKey:destinationViewController];
    }
}

@end
