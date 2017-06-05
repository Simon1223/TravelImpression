//
//  BaseCoderObject.m
//  MobileInterconnect
//
//  Created by CongHe on 17/5/3.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import "BaseCoderObject.h"
#import <objc/runtime.h>
@implementation BaseCoderObject 
// 归档
- (void)encodeWithCoder:(NSCoder*)encoder
{
    unsigned int count;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString* strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
    free(ivars);
}

// 解档
- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        unsigned int count;
        Ivar* ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char* name = ivar_getName(ivar);
            NSString* strName = [NSString stringWithUTF8String:name];
            NSString* strType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            id value = [decoder decodeObjectForKey:strName];
            if(value == nil){
                
                if([strType isEqualToString:@"c"]){
                    value = @(0);
                }else{
                    value = @"";
                }
            }
            [self setValue:value forKey:strName];
        }
        free(ivars);
    }
    return self;
}
@end
