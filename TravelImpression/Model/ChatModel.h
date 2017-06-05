//
//  ChatModel.h
//  MobileInterconnect
//
//  Created by huadong on 2017/5/5.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeLeft  = 0,  //左边
    UserTypeRight = 1,  //右边
};

@interface ChatModel : NSObject

@property (nonatomic, assign)UserType userType;
@property (nonatomic, strong)NSString *photoURL;
@property (nonatomic, strong)NSString *content;

@end
