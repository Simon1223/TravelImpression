//
//  UserModel.h
//  Speech
//
//  Created by huadong on 2017/5/25.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 用户数据模型
 */
@interface UserModel : AVUser<AVSubclassing>


/**
 性别 0：保密 1：男 2：女
 */
@property (nonatomic, assign) NSInteger sex;

/**
 头像
 */
@property (nonatomic, copy) NSString *photo;

/**
 所属城市
 */
@property (nonatomic, copy) NSString *city;

/**
 个性签名
 */
@property (nonatomic, copy) NSString *signature;

/**
 绑定QQ
 */
@property (nonatomic, copy) NSString *bindQQ;

/**
 绑定微信
 */
@property (nonatomic, copy) NSString *bindWeChat;

/**
 绑定微博
 */
@property (nonatomic, copy) NSString *bindWeibo;

- (instancetype)initWithID:(NSString *)userID;

@end


#pragma mark ------- 用户登录方法 -------
@interface UserModel (LoginAndLogOut)

/*
 * 用户登录
 * @param account 登录帐号
 * @param pass 登录密码 MD5加密
 * @param success 登录成功回调
 * @param failure 登录失败回调
 */
+ (void)loginWithAccount:(NSString *)account
                      pass:(NSString *)pass
                   success:(void (^) (UserModel *user) )success
                   failure:(void (^) (NSError *error) )failure;


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
                   failure:(void (^) (NSError *error) )failure;


/**
 获取验证码
 
 @param phone 手机号码
 @param success 回调
 */
+ (void)getAuthCodeWithPhone:(NSString *)phone success:(void (^)(BOOL success))success;

/**
 注册后设置登录密码
 
 @param user 用户
 @param password 密码
 @param success 回调
 */
+ (void)user:(UserModel *)user setPassword:(NSString *)password success:(void (^) (BOOL success))success;

/**
 自动登录

 @param completion 成功后回调
 @param failure 失败后回调
 */
+ (void)loginAutoCompletionBlock:(void(^)())completion
                      failureBlock:(void(^)())failure;


/*
 * 用户登录完成
 * @param block 用户登录完成回调
 */
+ (void)loginCompletion:(UserModel *)resultData
                    block:(void(^)())block;

/*
 * 用户登出完成
 * @param block 用户登出完成回调
 */
+ (void)logoutCompletionBlock:(void(^)())block;

@end


#pragma mark ------- 用户信息方法 -------
@interface UserModel(UserInfo)

/**
 *  获取用户信息
 *  @param userId 用户Id
 */
- (void)getUserInfoWithUserId:(NSInteger)userId
                      success:(void (^) (UserModel *result) )success
                      failure:(void (^) (NSError *error) )failure;

/**
 *  更新用户信息
 *  @param userInfo 要更新资料
 */
- (void)updateUserInfo:(UserModel *)userInfo
               success:(void (^) (UserModel *result) )success
               failure:(void (^) (NSError *error))failure;



#pragma mark - 获取/保存/更新登录用户信息

/**
 *  从UserDefault获取登录用户信息
 */
+ (UserModel *)getLoginUserFromUserDefault;


/**
 *  保存登录用户信息到UserDefault
 */
- (void)saveLoginUserToUserDefault:(UserModel *)member;


/**
 *  更新登录用户信息到UserDefault
 */
- (void)updateLoginUserToUserDefault:(UserModel *)member;


@end
