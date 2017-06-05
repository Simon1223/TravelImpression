//
//  HDMediator.h
//  Speech
//
//  Created by Simon on 2017/5/22.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ResultBlock)(NSString *startName , id result);

/**
 中间件
 */
@interface HDMediator : NSObject

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) ResultBlock resultBlock;

+ (HDMediator *)sharedInstace;

- (void)start:(NSString *)startViewController destination:(NSString *)destinationViewController params:(NSDictionary *)params;

- (void)destination:(NSString *)destinationViewController Return:(ResultBlock)result;

@end
