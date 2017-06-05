//
//  AddressBookModel.h
//  Speech
//
//  Created by Simon on 2017/5/18.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 联系人数据模型
 */
@interface AddressBookModel : NSObject


/**
 名称
 */
@property (nonatomic, copy) NSString *name;


/**
 电话号码
 */
@property (nonatomic, copy) NSString *phone;


@end
