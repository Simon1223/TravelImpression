//
//  FeaturedModel.h
//  Speech
//
//  Created by huadong on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 精选数据模型
 */
@interface FeaturedModel : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 地址数组
 */
@property (nonatomic, copy) NSArray *addressArray;

/**
 作者头像
 */
@property (nonatomic, copy) NSString *userPhoto;

@end
