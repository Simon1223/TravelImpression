//
//  UserModel.m
//  Speech
//
//  Created by huadong on 2017/5/25.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(void)load
{
    [UserModel registerSubclass];
}

+ (NSString *)parseClassName {
    return @"_User";
}

@end


@implementation UserModel (LoginAndLogOut)

/*
 * 用户密码登录
 * @param account 登录帐号
 * @param pass 登录密码 MD5加密
 * @param success 登录成功回调
 * @param failure 登录失败回调
 */
+ (void)loginWithAccount:(NSString *)account
                      pass:(NSString *)pass
                   success:(void (^) (UserModel *user) )success
                   failure:(void (^) (NSError *error) )failure
{
    NSString *phoneNumber = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //调用接口发送登录请求
    [UserModel logInWithMobilePhoneNumberInBackground:phoneNumber password:password block:^(AVUser *user, NSError *error) {
        if (!error)
        {
            UserModel *model = [UserModel currentUser];
            [UserModel loginCompletion:model block:nil];
            success(model);
        }
        else{
            failure(error);
        }
    }];
}

/*
 * 用户验证码登录
 * @param account 登录帐号
 * @param pass 验证码
 * @param success 登录成功回调
 * @param failure 登录失败回调
 */
+ (void)loginWithAccount:(NSString *)account
                    verify:(NSString *)verify
                   success:(void (^) (UserModel *user) )success
                   failure:(void (^) (NSError *error) )failure{
    
    //调用接口发送登录请求
    [UserModel signUpOrLoginWithMobilePhoneNumberInBackground:account smsCode:verify block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (!error)
        {
            UserModel *model = [UserModel currentUser];
            [UserModel loginCompletion:model block:nil];
            success(model);
        }
        else{
            failure(error);
        }
    }];
}


/**
 获取验证码

 @param phone 手机号码
 @param success 回调
 */
+ (void)getAuthCodeWithPhone:(NSString *)phone success:(void (^)(BOOL success))success
{
    [AVSMS requestShortMessageForPhoneNumber:phone options:AVShortMessageTypeText callback:^(BOOL succeeded, NSError * _Nullable error) {
        success(succeeded);
    } ];
}


/**
 注册后设置登录密码

 @param user 用户
 @param password 密码
 @param success 回调
 */
+ (void)user:(UserModel *)user setPassword:(NSString *)password success:(void (^) (BOOL success))success
{
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        success(succeeded);
    }];
}

/**
 自动登录

 @param completion 成功回调
 @param failure 失败回调
 */
+ (void)loginAutoCompletionBlock:(void(^)())completion
                      failureBlock:(void(^)())failure
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *platformDic = [userDefault dictionaryForKey:@"platform"];
    NSString *UUIDString = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if(platformDic.count >0){
        //第三方帐号登录
        
    }
    else
    {
        //账号密码登录
        NSString *phone = [userDefault stringForKey:@"phone"];
        NSString *pass = [userDefault stringForKey:@"password"];
        if(phone && pass){
            //调用接口发送登录请求
            [UserModel logInWithMobilePhoneNumberInBackground:phone password:pass block:^(AVUser *user, NSError *error) {
                if (!error)
                {
                    UserModel *model = [UserModel currentUser];
                    [UserModel loginCompletion:model block:completion];
                }
                else{
                    failure(error);
                }
            }];
        }
    }
}


/*
 * 用户登录完成
 * @param block 用户登录完成回调
 */
+ (void)loginCompletion:(UserModel *)user
                    block:(void(^)())block{
    
    if(user == nil) return;
    
    NSString *userId = [user objectForKey:@"objectId"];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"lastLoginId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.mobilePhoneNumber forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[GlobalTool sharedTool] setLoginID:userId];
    [[GlobalTool sharedTool] setLoginToken:user.sessionToken];
    
    [user saveLoginUserToUserDefault:user];
    
    
    //    //设置微信AppId，设置分享url，
    //    [UMSocialWechatHandler setWXAppId:@"wx862480bfeb2cc88f" appSecret:@"032f402b1e2a225c4bea3b6c5674557e" url:[[GlobalTool sharedTool] sharedURL]];
    //
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    //    [UMSocialQQHandler setQQWithAppId:@"1101689355" appKey:@"HbmnYwc3y8ImZZh7" url:[[GlobalTool sharedTool] sharedURL]];
    
    if(userId.length){
        
        NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastCity"];
        if (city.length ==0) {
            city = @"深圳市";
        }
        [self sendCity:city];
    }
}

//发送城市给后台
+ (void)sendCity:(NSString *)city
{

}

/*
 * 用户登出完成
 * @param block 用户登出完成回调
 */
+ (void)logoutCompletionBlock:(void(^)())block
{
    //删除登录用户数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"password"];
    [userDefault removeObjectForKey:@"realPassword"];
    
    [GlobalTool sharedTool].loginID = nil;
    [GlobalTool sharedTool].loginToken = nil;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:kLogoutDidFinishNotification object:nil];
    
    
    //如果是第三方登录,删除授权
//    NSDictionary *platformDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"platform"];
//    if(platformDic.count >0){
//        
//        
//        UMSocialPlatformType platformType = [[platformDic objectForKey:@"platform"] integerValue];
//        [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
//            
//            if(!error){
//                NSLog(@"删除授权===%@",result);
//                [[NSUserDefaults standardUserDefaults] setObject:nil  forKey:@"platform"];
//            }
//        }];
//        
//    }
//    
//    if(block){
//        block();
//    }
    
}

@end

#pragma mark ------- 用户信息方法 -------
@implementation UserModel(UserInfo)

/**
 *  获取用户信息
 *  @param userId 用户Id
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                      success:(void (^) (UserModel *result))success
                      failure:(void (^) (NSError *error) )failure{
    
    //调用接口获取用户信息
    UserModel *model = [UserModel objectWithClassName:@"_User" objectId:userId];
    if (model)
    {
        success(model);
    }
    else{
        failure(nil);
    }
}


/**
 *  更新用户信息
 *  @param userInfo 要更新资料
 */
- (void)updateUserInfo:(UserModel *)userInfo
               success:(void (^) (UserModel *result) )success
               failure:(void (^) (NSError *error))failure{
    
    [userInfo saveInBackground];
    success([UserModel currentUser]);
}



/**
 *  从UserDefault获取登录用户信息
 */
+ (UserModel *)getLoginUserFromUserDefault{
    
    NSString *lastLoginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastLoginId"];
    if (lastLoginId.length==0) {
        return nil;
    }
    NSData *encodedObject =[[NSUserDefaults standardUserDefaults] objectForKey:lastLoginId];
    UserModel *user = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
    return user;
}


/**
 *  保存登录用户信息到UserDefault
 */
- (void)saveLoginUserToUserDefault:(UserModel *)user{
    
    NSString *lastLoginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastLoginId"];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    if(lastLoginId.length >0 && encodedObject){
        
        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:lastLoginId];
    }
}


/**
 *  更新登录用户信息到UserDefault
 */
- (void)updateLoginUserToUserDefault:(UserModel *)user{
    
    NSString *lastLoginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastLoginId"];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:lastLoginId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
