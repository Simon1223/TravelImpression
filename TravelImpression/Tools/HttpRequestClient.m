//
//  HttpRequestClient.m
//  ShenMaDiDiClient
//
//  Created by GPMacMini on 14-6-3.
//  Copyright (c) 2014年 LiFei. All rights reserved.
//


#import "HttpRequestClient.h"


#define REQUEST_TIMEOUT_INTERVAL 30

@interface HttpRequestClient()

@end

@implementation HttpRequestClient

+ (HttpRequestClient *)sharedClient{
    
    static HttpRequestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[HttpRequestClient alloc] initWithBaseURL:[NSURL URLWithString:HttpBaseURL]];
        ((AFJSONResponseSerializer *)_sharedClient.responseSerializer).removesKeysWithNullValues = YES;
        // 设置非校验证书模式
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
        [_sharedClient.securityPolicy setValidatesDomainName:NO];
//        _sharedClient.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
        
        
    });
    
    return _sharedClient;
    
}


#pragma mark - 异步/同步 请求

/*
 * 请求参数添加token和版本号
 */
- (NSMutableDictionary *)addLoginTokenAndVersion:(NSDictionary *)param{
    
    NSString *token = [GlobalTool sharedTool].loginToken;
    if(!LOGIN_USERID && !token){
        token = @"";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    [dict setObject:token forKey:@"logintoken"];
    [dict setObject:AppTypeId forKey:@"appid"];
    [dict setObject:kResource forKey:@"platform"];
    [dict setObject:CURRENT_VER forKey:@"version"];
    [dict setObject:VersionChannel forKey:@"apptype"];
    
    return dict;
}


/*
 * 发送异步请求
 * @param method 请求方式 get post
 * @param url 请求地址
 * @param param 请求参数
 * @param successBlockHandler 请求成功回调
 */


-(void)sendAsyncHttpRequestForMethod:(NSString *)method
                                 url:(NSString *)url
                               param:(NSDictionary *)param
                             success:(HttpRequestSuccessBlockHandler)successBlockHandler fail:(HttpRequestFailBlockHandler)failBlockHandler
{    
    
    NSDictionary *dic = [self addLoginTokenAndVersion:param];
    
    //本地缓存设置，沙盒路径设置
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *pathString = path.lastObject;
    NSString *pathLast =[NSString stringWithFormat:@"/Caches/cn.didi365.ShenMaDiDiClient/%lu.text", (unsigned long)[url hash]];
    
    //创建字符串文件存储路径
    NSString *pathName =[pathString stringByAppendingString:pathLast];
    
    //第一次进入判断有没有文件夹，如果没有就创建一个
    NSString * textPath = [pathString stringByAppendingFormat:@"/Caches/cn.didi365.ShenMaDiDiClient"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:textPath]) {
        
        [[NSFileManager defaultManager]createDirectoryAtPath:textPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //请求成功Blcok
    void (^success)(NSURLSessionDataTask * _Nonnull, id _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //成功
   
        if(responseObject != nil){
            
            if([responseObject isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *jsonObject = (NSDictionary *)responseObject;
                NSInteger status = [[jsonObject objectForKey:@"status"] integerValue];
                if(status == -1){
                    
                    //强制登录
//                    [MemberModel doLogoutCompletionBlock:^{
//                        
//                        if(![GlobalTool sharedTool].isConflict){
//                            
//                            UIViewController *currentVC = [[GlobalTool sharedTool] currentViewController];
//                            if(![currentVC isKindOfClass:[InputBaseViewController class]])
//                            {
//                                
//                                if(![[GlobalTool sharedTool] isLoginAccount:currentVC]){
//                                    
//                                    if(currentVC.navigationController.viewControllers.count >1){
//                                        [currentVC.navigationController popToRootViewControllerAnimated:NO];
//                                    }
//                                    
//                                    UIViewController *toVc = [[GlobalTool sharedTool] currentViewController];
//                                    [GlobalTool showTopNoticeText:[jsonObject stringValueForKey:@"info"] superView:toVc.view];
//                                    
//                                    return;
//                                }
//                            }
//                            
//                            
//                        }
//                        
//                    }];
                }
                if(status == -2){
                    
                    //                  [SVProgressHUD dismiss];
                    NSString *updateURL = [[jsonObject objectForKey:@"data"] stringValueForKey:@"url"];
//                    if(!verManager){
//                        
//                        verManager =[[VersionManager alloc] init];
//                        [verManager showCompelUpdateAlertWithUpdateURL:updateURL buttonClickFinshBlock:^{
//                            verManager = nil;
//                        }];
//                        
//                    }
                    
                }
                
            }
            
            
            if([method isEqualToString:@"GET"]){
                [responseObject writeToFile:pathName atomically:YES];
            }
            
            if(successBlockHandler){
                successBlockHandler(responseObject);
            }
        }

    
    };
    
    //请求失败Blcok
    void (^failure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        //失败
#if DEBUG
        NSLog(@"http requst error %@",[error description]);
#endif
        [SVProgressHUD dismiss];
        if(error.code == NSURLErrorNotConnectedToInternet){
            
            
            NSString * cachePath = pathName;
            if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
                //从本地读缓存文件
                NSDictionary *responseObject = [NSDictionary dictionaryWithContentsOfFile:cachePath];
                
                if(responseObject){
                    
                    if(successBlockHandler){
                        successBlockHandler(responseObject);
                    }
                }
                else{
                    
                    if(failBlockHandler){
                        failBlockHandler(error);
                    }
                    
                }
                
            }else{
                
                if(failBlockHandler){
                    failBlockHandler(error);
                }
            }
            
            
            
        }else{
            
            if(failBlockHandler){
                failBlockHandler(error);
            }
            
        }

        
    };
    
    
    //调试状态下使用GET请求
    NSURLSessionDataTask *dataTask = nil;
#if DEBUG
    dataTask = [self GET:url parameters:dic progress:nil success:success failure:failure];
#else
    dataTask = [self POST:url parameters:dic progress:nil success:success failure:failure];
#endif
    NSLog(@"request ====%@",dataTask.currentRequest.URL);

}





#pragma mark 异步get/post请求


/*
 * 发送异步get请求
 * @param url 请求地址
 * @param param 请求参数
 */
-(void)sendGetHttpRequestForUrl:(NSString *)url param:(NSDictionary *)param success:(HttpRequestSuccessBlockHandler)successBlockHandler fail:(HttpRequestFailBlockHandler)failBlockHandler{
    
    [self sendAsyncHttpRequestForMethod:@"GET"
                                    url:url
                                  param:param
                                success:successBlockHandler
                                   fail:failBlockHandler];
}


/*
 * 发送异步post请求
 * @param url 请求地址
 * @param param 请求参数
 */
 
 -(void)sendPostHttpRequestForUrl:(NSString *)url param:(NSDictionary *)param
 success:(HttpRequestSuccessBlockHandler)successBlockHandler fail:(HttpRequestFailBlockHandler)failBlockHandler{
 
     [self sendAsyncHttpRequestForMethod:@"POST"
                                     url:url
                                   param:param
                                 success:successBlockHandler
                                    fail:failBlockHandler];
 }



#pragma mark - 上传语音/图片




//上传图片
-(void)uploadImageForUrl:(NSString *)url
                   param:(NSDictionary *)param
                imgArray:(NSArray *)imgArray
                 success:(HttpRequestSuccessBlockHandler)successBlockHandler
                    fail:(HttpRequestFailBlockHandler)failBlockHandler
{
    
    
    [self POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i<[imgArray count]; i++) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat            = @"yyyyMMddHHmmss";
            NSString *str                   = [formatter stringFromDate:[NSDate date]];
            NSString *fileName              = [NSString stringWithFormat:@"%@.jpg", str];
            
            NSData *imageData = UIImageJPEGRepresentation([imgArray objectAtIndex:i],0.3);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image_%@",@(i)] fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject != nil){
            if(successBlockHandler){
                successBlockHandler(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
#if DEBUG
        NSLog(@"http requst error %@",[error description]);
#endif
        [SVProgressHUD dismiss];
        if(error.code == NSURLErrorNotConnectedToInternet){
            
            [GlobalTool showTopNoticeText:DefaultNetError superView:[UIApplication sharedApplication].keyWindow];
        }
        
        if(failBlockHandler){
            failBlockHandler(error);
        }

        
    }];
    
    
    

    
   
    
}

//上传语音
-(void)uploadAudioForUrl:(NSString *)url
                   param:(NSDictionary *)param
               audioData:(NSData *)audioData
                 success:(HttpRequestSuccessBlockHandler)successBlockHandler
                    fail:(HttpRequestFailBlockHandler)failBlockHandler{
    
    [self POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:audioData name:@"voice" fileName:@"text.amr" mimeType:@"audio/amr"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject != nil){
            if(successBlockHandler){
                successBlockHandler(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
#if DEBUG
        NSLog(@"http requst error %@",[error description]);
#endif
        [SVProgressHUD dismiss];
        if(error.code == NSURLErrorNotConnectedToInternet){
            
            [GlobalTool showTopNoticeText:DefaultNetError superView:[UIApplication sharedApplication].keyWindow];
        }
        
        if(failBlockHandler){
            failBlockHandler(error);
        }
        
        
    }];

}


//=====================================================================================

@end
