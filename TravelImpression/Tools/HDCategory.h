//
//  HDCategory.h
//  Speech
//
//  Created by Simon on 13-11-25.
//  Copyright (c) 2013年 SimonMBP All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILabel+ContentSize.h"

@interface NSString (StringHelper)

- (NSString *)trimWhitespace;
- (NSString *)utf8TrimWhitespace;
- (NSUInteger)numberOfLines;
- (BOOL)isContainsString:(NSString *)aString;
- (CGSize)sizeForWidth:(CGFloat)width Font:(int)font;
- (CGSize)sizeForHeight:(CGFloat)height Font:(int)font;
- (NSString *)htmlToString;

@end


@interface UIImage (ImageHelper)

+ (UIImage *)getImageFromView:(UIView *)view;
- (UIImage *)getSubImage:(CGRect)rect;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)fullToSize:(float)fullWidth WithImageSize:(CGSize)imageSize;
+ (UIImage *)createImageWithColor:(UIColor*)color :(CGRect)frame;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)blurImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end





@interface NSDictionary (DictionaryHelper)

- (NSString *)stringValueForKey:(id)key;

- (NSMutableDictionary *)dictionaryValueForKey:(id)key;

- (NSMutableArray *)arrayValueForKey:(id)key;



@end


@interface UIColor(UIColorHelper)

+ (UIColor *)colorWithHexString:(NSString *)color;

@end



@interface UIView (UIViewHelper)

+ (void)showAddOne:(UIButton *)superView;

//view添加边界
- (void)borderWithRadius:(CGFloat)radius color:(UIColor *)color width:(CGFloat)width;
@end



@interface UIButton (UIButtonHelper)

- (void)setButtonRoundedCorners;
@end



