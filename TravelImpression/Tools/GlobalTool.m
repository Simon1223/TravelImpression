//
//  GlobalTool.m
//  ShenMaDiDiClient
//
//  Created by GPMacMini on 14-6-5.
//  Copyright (c) 2014年 LiFei. All rights reserved.
//

#import "GlobalTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"
#import "HDNavigationController.h"
#import "LocalAuthentication/LocalAuthentication.h"

@implementation GlobalTool


+(GlobalTool *)sharedTool{
    
    static GlobalTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[GlobalTool alloc] init];
    
    });
     return tool;
}

- (instancetype)init{
    self=[super init];
    if (self) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT+20+44)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.5;
    }
    return self;
}

/**
 *  判断当前用户是否登录
 */
+ (BOOL)isLogin{
    
    return [GlobalTool sharedTool].loginToken.length >0;
}


/**
 *  判断用户是否登录
 *
 *  @param target 当前页面
 *
 *  @return 是否登录
 */
-(BOOL)isLoginAccount:(UIViewController *)target{
    
    if(![GlobalTool isLogin]){
        
        UIViewController *nextVC = nil;
        NSString *lastLoginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastLoginId"];
        
        if(lastLoginId.length){
            //已有账号登录
//            UserLoginViewController *userLoginVC = [UserLoginViewController new];
//            nextVC = userLoginVC;
        }
        else{
            
            //初始登录
//            LoginViewController *loginVC = [LoginViewController new];
//            nextVC = loginVC;
        }
        
        HDNavigationController *naviga = [[HDNavigationController alloc] initWithRootViewController:nextVC];
        [target presentViewController:naviga animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}


+ (UILabel *)createLabel:(CGRect)frame title:(NSString *)title superView:(UIView *)superView font:(UIFont *)font color:(UIColor *)textColor alignment:(NSTextAlignment)alignment
{
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.backgroundColor = [UIColor clearColor];
    if (title.length > 0) {
        l.text = title;
    }
    
    l.textColor = textColor;
    l.font = font;
    l.textAlignment = alignment;
    [superView addSubview:l];
    return l;
}

+ (UIButton *)createButton:(CGRect)frame title:(NSString*)title image:(NSString*)image superView:(UIView *)superView target:(id)target selector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image.length > 0)
    {
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    
    if (title.length > 0)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [superView addSubview:btn];
    if (target&&selector) {
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}



+ (UIImageView *)createImageView:(CGRect)frame imageName:(NSString *)imageName superView:(UIView *)superView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    [superView addSubview:imageView];
    if (imageName.length > 0) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    return imageView;
}

+ (UITableViewCell *)getCellWithSuperView:(UIView *)sender
{
    UITableViewCell *myCell = (UITableViewCell *)sender.superview;
    while (![myCell isKindOfClass:[UITableViewCell class]]) {
        myCell = (UITableViewCell *)myCell.superview;
    }
    return myCell;
}


#pragma mark - 验证手机号码 邮箱


+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

+(BOOL)isValidateUserAndPassword:(NSString*)str{
    NSString *passRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [passTest evaluateWithObject:str];
    
}

+(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13,14,17,15,18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(BOOL)isValidateFloat:(NSString *)floatString
{
    NSString *str = @"^(?:0\\.\\d{1,3}|(?!0)\\d+(?:\\.\\d{1,3})?)$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [strTest evaluateWithObject:floatString];
}

+(BOOL)isValidateFloatJustOne:(NSString *)floatString
{
    NSString *str = @"^(?:0\\.\\d{1,2}|(?!0)\\d+(?:\\.\\d{1,2})?)$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [strTest evaluateWithObject:floatString];
}

+(BOOL)isValidateInt:(NSString *)intString
{
    NSString *str = @"^\[1-9]\[0-9]{0,2}|0$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [strTest evaluateWithObject:intString];
}

//正整数
+(BOOL)isPositiveInteger:(NSString *)intString
{
    NSString *str = @"^\[1-9][0-9]*$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [strTest evaluateWithObject:intString];
}

+(BOOL)isValidateMileage:(NSString *)intString
{
    NSString *str = @"^\[1-9]\[0-9]{0,5}|0$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [strTest evaluateWithObject:intString];
}


//校验身份证号码
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

#pragma mark 格式化时间

+(NSDate *)dateForString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

+(NSDate *)dateForLongString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SS"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+(NSString *)stringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)YMDStringForString:(NSString *)dateString
{
    NSDate *date = [self dateForString:dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

/**
 *  格式化时间
 *
 *  @param dateStr 要格式化的时间
 *  @param format  格式化 格式 如 HH:mm    yyyy-MM-dd
 *
 *  @return 格式化过时间
 */
+(NSString *)dateFormatter:(NSString *)dateStr format:(NSString *)format
{
    NSDate *date = [GlobalTool dateForString:dateStr];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:format];
    NSString *newDateStr = [newDateFormatter stringFromDate:date];
    return  newDateStr;
}


/**
 * 计算指定时间与当前的时间差
 * @param dateStr   某一指定时间String
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSString *)dateStr
{
    NSDate *date = [GlobalTool dateForString:dateStr];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) ==1){
        result = [NSString stringWithFormat:@"昨天 %@",[GlobalTool dateFormatter:dateStr format:@"HH:mm"]];
    }
    else if((temp = temp/24) ==2){
        result = [NSString stringWithFormat:@"前天 %@",[GlobalTool dateFormatter:dateStr format:@"HH:mm"]];
    }
    else{
        result = [GlobalTool dateFormatter:dateStr format:@"yyyy-MM-dd HH:mm"];
    }
    
    return  result;
}


/**
 计算指定时间与当前的时间差

 @param date 时间Date
 @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentDate:(NSDate *)date{
    
    NSString *dateStr = [GlobalTool stringForDate:date];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) ==1){
        result = [NSString stringWithFormat:@"昨天 %@",[GlobalTool dateFormatter:dateStr format:@"HH:mm"]];
    }
    else if((temp = temp/24) ==2){
        result = [NSString stringWithFormat:@"前天 %@",[GlobalTool dateFormatter:dateStr format:@"HH:mm"]];
    }
    else{
        
        result = [GlobalTool dateFormatter:dateStr format:@"yyyy-MM-dd HH:mm"];
    }
    
    return  result;
}


+ (NSString *)getTimeDiffString:(NSTimeInterval)timestamp {
    timestamp = timestamp / 1000.0f;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *todate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *today = [NSDate date]; //当前时间
    unsigned int unitFlag = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *gap = [cal components:unitFlag fromDate:today toDate:todate options:0]; //计算时间差
    
    if (ABS([gap day]) > 0) {
        return [NSString stringWithFormat:@"%ld天前", (long)(ABS([gap day]))];
    }
    else if (ABS([gap hour]) > 0) {
        return [NSString stringWithFormat:@"%ld小时前", (long)(ABS([gap hour]))];
    }
    else {
        return [NSString stringWithFormat:@"%ld分钟前",  (long)(ABS([gap minute]))];
    }
}



#pragma mark - 格式化手机号码
+ (NSString *)mobileFormatter:(NSString *)mobile{
    
    NSString *start = @"+86 ";
    NSString *str1 =[mobile substringWithRange:NSMakeRange(0,3)];
    NSString *str2 =[mobile substringWithRange:NSMakeRange(3,4)];
    NSString *str3 =[mobile substringWithRange:NSMakeRange(7,4)];
    NSString *string = [NSString stringWithFormat:@"%@%@-%@-%@",start,str1,str2,str3];
    return string;
}

#pragma mark  密码加密
//停车密码加密 不可逆加密：MD5(MD5(密码) + 用户名)
+(NSString *)md5Pass:(NSString*)pass username:(NSString*)username{
    NSString * md5p = [GlobalTool md5:pass];
    NSString * pn = [md5p stringByAppendingString:username];
    return [GlobalTool md5:pn];
}

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}


+ (void)showTopNoticeText:(NSString *)text superView:(UIView *)superView{
    UIButton *btn = (UIButton *)[superView viewWithTag:1111];
    if (btn == nil) {
        CGRect startFrame = CGRectMake(0.f, -64, DEVICE_WIDTH, 42.f);
        CGRect stopFrame = CGRectMake(0.f, 0, DEVICE_WIDTH, 42.f);
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        messageButton.frame = startFrame;
        messageButton.tag = 1111;
        [messageButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        messageButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [messageButton setTitle:text forState:UIControlStateNormal];
        [superView addSubview:messageButton];
        
        [UIView animateWithDuration:0.5f animations:^{
            messageButton.frame = stopFrame;
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.5f animations:^{
                    messageButton.frame = startFrame;
                } completion:^(BOOL finished) {
                    [messageButton removeFromSuperview];
                }];
            });
        }];
    }
}


+ (CGFloat)heightForText:(NSString *)text
                    font:(UIFont *)font
                maxWidth:(CGFloat)maxWidth
{
    
    if (text.length == 0) {
        return 0;
    }
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName : font }
                                           context:nil];
    CGSize textSize = CGRectIntegral(stringRect).size;
    return textSize.height;
    
}

+ (CGFloat)widthForText:(NSString *)text
                   font:(UIFont *)font
              maxHeight:(CGFloat)maxHeight
{
    
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,maxHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName : font }
                                           context:nil];
    CGSize textSize = CGRectIntegral(stringRect).size;
    
    return textSize.width;
}

#pragma mark - 屏蔽表情特殊字符
+ (BOOL)isIncludeSpecialCharact:(NSString *)str
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSString *specialCharact = @"-~￥#&*<>《》()[]{}【】^@￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€?？、`!！!。，,.:;〔〕『〖〗』¢₽₩€£$¿¡·|";
    NSString *temp = nil;
    BOOL isInclude = NO;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    str = [regex stringByReplacingMatchesInString:str
                                          options:0
                                            range:NSMakeRange(0, [str length])
                                     withTemplate:@"#"];
    for(int i =0; i < [str length]; i++)
    {
        temp = [str substringWithRange:NSMakeRange(i, 1)];
        NSRange urgentRange = [specialCharact rangeOfString:temp];
        if (urgentRange.length > 0)
        {
            isInclude = YES;
            break;
        }
    }
    return isInclude;
}

+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
+ (BOOL)isNineGridKeyboard:(NSString *)text
{
    if ([text isEqualToString:@"➋"]||[text isEqualToString:@"➌"]||[text isEqualToString:@"➍"]||[text isEqualToString:@"➎"]||[text isEqualToString:@"➏"]||[text isEqualToString:@"➐"]||[text isEqualToString:@"➑"]||[text isEqualToString:@"➒"]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark --字典转json字符串

/**
 NSDictionary转换成JSON字符串

 @param dic 字典
 @return JSON字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  JSON字符串转换成NSDictionary
 *
 *  @param jsonStr JSON字符串
 *
 *  @return 转换后NSDictionary
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr
{
    NSString *str = [self trimWithString:jsonStr];
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return dic;
}

+ (NSString *)trimWithString:(NSString *)str
{
    NSString *string = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return string;
}


#pragma mark --获取通讯录数组
+(NSArray*)getAddressBookPeople{

    NSMutableArray * addressBookArray = [NSMutableArray array];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //拿到所有联系人
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //数组数量
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    for (int i = 0; i < peopleCount; i++) {
        AddressBookModel * model = [AddressBookModel new];
        //拿到一个人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        //拿到姓名
        //姓
        NSString *lastNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty)?:@"";
        //名
        NSString *firstNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty)?:@"";
        model.name = [NSString stringWithFormat:@"%@%@",lastNameValue,firstNameValue];
        //拿到多值电话
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        //多值数量
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (int j = 0; j < phoneCount ; j++) {
            //电话标签本地化(例如是住宅,工作等)
            NSString *phoneLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phones, j));
            //拿到标签下对应的电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
            phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if (!model.phone) {
                model.phone = phoneValue;
                break;
            }
        }
        CFRelease(phones);
        
        [addressBookArray addObject:model];
    }
    CFRelease(addressBook);
    CFRelease(peopleArray);
    
    return addressBookArray;
}



+ (void)alertMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}


#pragma mark ---------------选择时间-----------------
- (void)chooseTimeWithMinTime:(NSDate *)minDate MaxTime:(NSDate *)maxDate NowTime:(NSDate *)nowDate Block:(ChooseTimeBlock)block
{
    chooseTimeBlock = block;
    
    [pickerBackImageView removeFromSuperview];
    pickerBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (DEVICE_HEIGHT+64), DEVICE_WIDTH, 200)];
    pickerBackImageView.backgroundColor = [UIColor whiteColor];
    pickerBackImageView.userInteractionEnabled = YES;
    
    UIButton *leftButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButtton.frame = CGRectMake(10, 10, 60, 30);
    [leftButtton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButtton addTarget:self action:@selector(leftOrRight:) forControlEvents:UIControlEventTouchUpInside];
    leftButtton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    leftButtton.tag = 0;
    [leftButtton setBackgroundImage:[UIImage imageNamed:@"btn_small_1.png"] forState:UIControlStateNormal];
    [leftButtton setBackgroundImage:[UIImage imageNamed:@"btn_small_1.png"] forState:UIControlStateHighlighted];
    [leftButtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerBackImageView addSubview:leftButtton];
    
    UIButton *rightButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButtton.frame = CGRectMake(pickerBackImageView.frame.size.width-70, 10, 60, 30);
    [rightButtton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButtton addTarget:self action:@selector(leftOrRight:) forControlEvents:UIControlEventTouchUpInside];
    rightButtton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    rightButtton.tag = 1;
    [rightButtton setBackgroundImage:[UIImage imageNamed:@"btn_small_1.png"] forState:UIControlStateNormal];
    [rightButtton setBackgroundImage:[UIImage imageNamed:@"btn_small_1.png"] forState:UIControlStateHighlighted];
    [rightButtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerBackImageView addSubview:rightButtton];
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, 40, DEVICE_WIDTH, 200);
    datePicker.backgroundColor = [UIColor clearColor];
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    [pickerBackImageView addSubview:datePicker];
    [datePicker setDate:nowDate];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [datePicker setCalendar:[NSCalendar currentCalendar]];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    datePicker.minimumDate = minDate;
    if (maxDate) {
        datePicker.maximumDate = maxDate;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:[GlobalTool sharedTool].shadowView];
    [[UIApplication sharedApplication].keyWindow addSubview:pickerBackImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPicker)];
    [[GlobalTool sharedTool].shadowView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.25 animations:^{
        //[GlobalTool sharedTool].shadowView.alpha = 0.6;
        pickerBackImageView.frame = CGRectMake(0, (DEVICE_HEIGHT-200), DEVICE_WIDTH, 200);
    }];
}

-(void)hiddenPicker
{
    [UIView animateWithDuration:0.25 animations:^{
        pickerBackImageView.frame = CGRectMake(0, (DEVICE_HEIGHT+64), DEVICE_WIDTH, 200);
    } completion:^(BOOL finished) {
        //[GlobalTool sharedTool].shadowView.hidden = YES;
        [[GlobalTool sharedTool].shadowView removeFromSuperview];
        [pickerBackImageView removeFromSuperview];
        pickerBackImageView = nil;
        datePicker = nil;
    }];
}

#pragma mark 点击事件

- (void)leftOrRight:(UIButton *)sendr
{
    if (sendr.tag == 1)
    {
        if([dateString isEqualToString:@""]||dateString == nil)
        {
            NSDate *dates = [NSDate dateWithTimeIntervalSinceNow:60*30];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *dateStr = [formatter stringFromDate:dates];
            dateString = dateStr;
        }
        chooseTimeBlock(dateString);
        dateString = @"";
    }
    [self hiddenPicker];
}

//点击textfield获取选择有效时间
- (void)chooseDate:(UIDatePicker *)sender
{
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:selectedDate];
    dateString = dateStr;
}

/*
#pragma mark -----------选择照片--------------
- (void)chooseImageWithMaxCount:(NSInteger)count viewController:(UIViewController *)viewController photoBlock:(ChoosePhotoBlock)block
{
    choosePhotoBlock = block;
    photoCount = count;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [viewController.navigationController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    if(assets.count ==0) return;
    
    NSMutableArray *chooseImages = [NSMutableArray new];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [chooseImages insertObject:tempImg atIndex:i];
    }
    
    choosePhotoBlock(chooseImages);
}


-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSString *title = [NSString stringWithFormat:@"你最多只能选择%ld照片",(long)photoCount];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (picker.indexPathsForSelectedItems.count == picker.maximumNumberOfSelection)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alertView show];
        }
    });
}
 */

#pragma mark ------指纹识别------
+ (void)touchIDRecognitionWithBlock:(void(^)(BOOL flag,NSString *string))block
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        block(NO,@"系统版本太低，不支持指纹识别");
        return;
    }
    LAContext *context = [LAContext new];
    //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"输入验证码";
    context.maxBiometryFailures = [NSNumber numberWithInt:5];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                             error:&error]) {
        NSLog(@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"验证成功 刷新主界面");
                        block(success,@"验证成功");
                    }else{
                        NSLog(@"%@",error.localizedDescription);
                        switch (error.code) {
                            case LAErrorSystemCancel:
                            {
                                NSLog(@"系统取消授权，如其他APP切入");
                                break;
                            }
                            case LAErrorUserCancel:
                            {
                                NSLog(@"用户取消验证Touch ID");
                                break;
                            }
                            case LAErrorAuthenticationFailed:
                            {
                                NSLog(@"授权失败");
                                break;
                            }
                            case LAErrorPasscodeNotSet:
                            {
                                NSLog(@"系统未设置密码");
                                break;
                            }
                            case LAErrorTouchIDNotAvailable:
                            {
                                NSLog(@"设备Touch ID不可用，例如未打开");
                                break;
                            }
                            case LAErrorTouchIDNotEnrolled:
                            {
                                NSLog(@"设备Touch ID不可用，用户未录入");
                                break;
                            }
                            case LAErrorUserFallback:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    NSLog(@"用户选择输入密码，切换主线程处理");
                                    block(NO,@"验证失败，用户选择输入密码，切换主线程处理");
                                }];
                                break;
                            }
                            default:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    NSLog(@"其他情况，切换主线程处理");
                                }];
                                break;
                            }
                        }
                    }
                }];
    }else{
        block(NO,@"不支持指纹识别");
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        NSLog(@"%@",error.localizedDescription);
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"密码解锁" reply:^(BOOL success, NSError * _Nullable error){
            if (success) {
                block(success,@"验证成功");
            }
            else
            {
                block(success,@"验证失败");
            }
            NSLog(@"LAPolicyDeviceOwnerAuthentication -- %@", error);
            
        }];
    }
}


@end
