//
//  GlobalTool.h
//  ShenMaDiDiClient
//
//  Created by GPMacMini on 14-6-5.
//  Copyright (c) 2014年 LiFei. All rights reserved.
//

typedef void (^ChooseTimeBlock)(NSString *timeString);
typedef void (^ChoosePhotoBlock)(NSArray *photos);

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <pthread.h>


@interface GlobalTool : NSObject

{
    void(^confirmBlcok)(NSDictionary*dic);
    UIView * shadeView;
    UIButton * selectBtn;
    
    ChooseTimeBlock chooseTimeBlock;
    ChoosePhotoBlock choosePhotoBlock;
    NSInteger photoCount;
    UIImageView *pickerBackImageView;
    UIDatePicker *datePicker;
    NSString *dateString;
}


/**
 阴影层
 */
@property(strong) UIView *shadowView;
//登录用户id
@property(nonatomic,strong) NSString *loginID;
@property(nonatomic,strong) NSString *loginToken;


+(GlobalTool *)sharedTool;


/**
 *  判断当前用户是否登录
 */
+ (BOOL)isLogin;

/**
 *  判断用户是否登录
 *
 *  @param target 当前页面
 *
 *  @return 是否登录
 */
-(BOOL)isLoginAccount:(UIViewController *)target;

/**
 创建Label

 @param frame 坐标
 @param title 标题
 @param superView 所属View
 @param font 字体
 @param textColor 字体颜色
 @return Label
 */
+(UILabel *)createLabel:(CGRect)frame title:(NSString *)title superView:(UIView *)superView font:(UIFont *)font color:(UIColor*)textColor alignment:(NSTextAlignment)alignment;


/**
 创建Button

 @param frame 坐标
 @param title 标题
 @param image 按钮图片
 @param superView 所属View
 @param target 事件响应者
 @param selector 按钮事件
 @return button
 */
+(UIButton *)createButton:(CGRect)frame title:(NSString*)title image:(NSString*)image superView:(UIView *)superView target:(id)target selector:(SEL)selector;


/**
 创建ImageView

 @param frame 坐标
 @param imageName 图片
 @param superView 所属view
 @return imageview
 */
+(UIImageView *)createImageView:(CGRect)frame imageName:(NSString *)imageName superView:(UIView *)superView;


/**
 根据cell上的按钮获取cell

 @param sender 按钮
 @return cell
 */
+ (UITableViewCell *)getCellWithSuperView:(UIView *)sender;

#pragma mark 验证手机号码 邮箱 用户名/密码 /身份证号
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateUserAndPassword:(NSString*)str;
+ (BOOL)isValidateFloat:(NSString *)floatString;
+ (BOOL)isValidateFloatJustOne:(NSString *)floatString;
+ (BOOL)isValidateInt:(NSString *)intString;
+ (BOOL)isPositiveInteger:(NSString *)intString;
+ (BOOL)isValidateMileage:(NSString *)intString;
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;
#pragma mark 格式化时间
+ (NSDate *)dateForString:(NSString *)dateStr;
+ (NSDate *)dateForLongString:(NSString *)dateString;
+ (NSString *)stringForDate:(NSDate *)date;
+ (NSString *)YMDStringForString:(NSString *)dateString;
+ (NSString *)dateFormatter:(NSString *)dateStr format:(NSString *)format;
+ (NSString *)compareCurrentTime:(NSString *)dateStr;
+ (NSString *)compareCurrentDate:(NSDate *)date;

#pragma mark - 格式化手机号码
+ (NSString *)mobileFormatter:(NSString *)mobile;

#pragma mark  密码加密
+(NSString *)md5Pass:(NSString*)pass username:(NSString*)username;

#pragma mark  MD5加密
+ (NSString *)md5:(NSString *)str;

#pragma mark - 头部提示
+ (void)showTopNoticeText:(NSString *)text superView:(UIView*)superView;


#pragma mark - 动态计算文字高度
+ (CGFloat)heightForText:(NSString *)text
                    font:(UIFont *)font
                maxWidth:(CGFloat)maxWidth;

#pragma mark - 动态计算文字宽度
+ (CGFloat)widthForText:(NSString *)text
                   font:(UIFont *)font
              maxHeight:(CGFloat)maxHeight;

#pragma mark - 屏蔽表情特殊字符
+ (BOOL)isIncludeSpecialCharact: (NSString *)str;

#pragma mark - 剔除表情
+ (NSString *)disable_emoji:(NSString *)text;
+ (BOOL)isNineGridKeyboard:(NSString *)text;

#pragma mark --判断登录
+ (BOOL)isLogin;

#pragma mark --获取通讯录信息
+(NSArray*)getAddressBookPeople;

#pragma mark --弹出窗提示
+ (void)alertMessage:(NSString *)message;

#pragma mark --字典转json字符串

/**
 NSDictionary转换成JSON字符串
 
 @param dic 字典
 @return JSON字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 JSON字符串转换成NSDictionary
 @param jsonStr JSON字符串
 @return 转换后NSDictionary
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr;

#pragma mark ----选择时间----
- (void)chooseTimeWithMinTime:(NSDate *)minDate MaxTime:(NSDate *)maxDate NowTime:(NSDate *)nowDate Block:(ChooseTimeBlock)block;

#pragma mark ----选择图片----
- (void)chooseImageWithMaxCount:(NSInteger)count viewController:(UIViewController *)viewController photoBlock:(ChoosePhotoBlock)block;
//指纹识别
+ (void)touchIDRecognitionWithBlock:(void(^)(BOOL flag,NSString *string))block;

@end
