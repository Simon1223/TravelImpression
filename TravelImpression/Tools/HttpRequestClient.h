//
//  HttpRequestClient.h
//  ShenMaDiDiClient
//
//  Created by GPMacMini on 14-6-3.
//  Copyright (c) 2014年 LiFei. All rights reserved.
//


#import "AFNetworking.h"


/*
 * http 网络请求工具类
 */



/**
 *  异步请求成功后回调
 *  @param resultData 请求成功返回json数据
 */
typedef void (^HttpRequestSuccessBlockHandler)(NSDictionary *resultData);


/**
 *  异步请求失败后回调
 *  @param error 请求失败返回错误
 */
typedef void (^HttpRequestFailBlockHandler)(NSError *error);


@interface HttpRequestClient : AFHTTPSessionManager


+ (HttpRequestClient *)sharedClient;


#pragma mark  请求相关方法

/*
 * 发送异步get请求
 * @param url 请求地址
 * @param param 请求参数
 */
-(void)sendGetHttpRequestForUrl:(NSString *)url
                          param:(NSDictionary *)param
                        success:(HttpRequestSuccessBlockHandler)successBlockHandler fail:(HttpRequestFailBlockHandler)failBlockHandler;

/*
 * 发送异步post请求
 * @param url 请求地址
 * @param param 请求参数
 */
-(void)sendPostHttpRequestForUrl:(NSString *)url
                           param:(NSDictionary *)param
                         success:(HttpRequestSuccessBlockHandler)successBlockHandler
                            fail:(HttpRequestFailBlockHandler)failBlockHandler;



#pragma mark  上传相关方法
//上传图片
-(void)uploadImageForUrl:(NSString *)url
                   param:(NSDictionary *)param
                imgArray:(NSArray *)imgArray
                 success:(HttpRequestSuccessBlockHandler)successBlockHandler
                    fail:(HttpRequestFailBlockHandler)failBlockHandler;

//上传语音
-(void)uploadAudioForUrl:(NSString *)url
                   param:(NSDictionary *)param
               audioData:(NSData *)audioData
                 success:(HttpRequestSuccessBlockHandler)successBlockHandler
                    fail:(HttpRequestFailBlockHandler)failBlockHandler;




@end
