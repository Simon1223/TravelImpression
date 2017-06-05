//
//  HttpWebViewController.m
//  ShenMaDiDiClient
//
//  Created by DiDi365 on 15/10/30.
//  Copyright © 2015年 HengTu. All rights reserved.
//

#import "HttpWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


// Log levels: off, error, warn, info, verbose


/**
 *  定义JS要调用的方法
 */
@protocol JSObjectProtocol <JSExport>



/**
 *  打开分享
 *
 *  @param shared 分享相关参数
 */
- (void)openShared:(JSValue *)value;


/**
 *  返回按钮控制
 *
 *  @param value 网络链接
 */
- (void)gotoBack:(JSValue *)value;


/**
 *  打开一个网络页面
 *  本地有页面跳转效果
 *  @param value 网络链接
 */
- (void)openWebView:(JSValue *)value;



/**
 *  打开二维码扫描页面
 *  本地有页面跳转效果
 *  @param value 扫描完成回调
 */
- (void)openScanView:(JSValue *)value;




@end



@interface HttpWebViewController()<JSObjectProtocol>
{
    NSDictionary *sharedDic;
    NSString *lastURL;
    BOOL isRewardPoint;
}

@property(nonatomic,strong) NSString *backURL;

@end


@implementation HttpWebViewController


- (instancetype)initWithURLString:(NSString *)urlString
                        showTitle:(BOOL)showTitle{
    

   
    if(self == [super initWithURLString:[self addUserIdAndTokenWithURL:urlString]]){
        

        self.showPageTitles = showTitle;
        self.isGoRoot = NO;
    }
    return self;
    
}

- (instancetype)initWithPathString:(NSString *)pathString
                        showTitle:(BOOL)showTitle
{
    if(self == [super initWithURL:[NSURL fileURLWithPath:pathString]]){
        
        self.showPageTitles = showTitle;
        self.isGoRoot = NO;
    }
    return self;
    
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.loadingBarTintColor = [UIColor blueColor];
    self.isGoPrevious = NO;
    self.navigationButtonsHidden = YES;
    self.showUrlWhileLoading = NO;
    self.isLogin = [GlobalTool isLogin];
    self.webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    
    [self seupTopButton];
    
    __block JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    jsContext[@"JavaScriptInterface"] = self;
   
    
    __weak HttpWebViewController *safeSelf = self;
    [self setLoadFinishHandler:^{
        
        jsContext = [safeSelf.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
        };
        jsContext[@"JavaScriptInterface"] = safeSelf;
        
    }];
    
    self.shouldStartLoadRequestHandler = ^BOOL(NSURLRequest *request, UIWebViewNavigationType navigationType){
      
        return  [safeSelf shouldStartLoadRequest:request];
        
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    lastURL = nil;

    if(self.isLogin != [GlobalTool isLogin]){
        
        NSString *requestURL = self.url.absoluteString;
        NSString *httpURL = [self addUserIdAndTokenWithURL:requestURL];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpURL]];
        [self.webView loadRequest:request];
        self.isLogin = [GlobalTool isLogin];
        self.isGoPrevious = YES;
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//   [self.webView stringByEvaluatingJavaScriptFromString:@"(document.getElementsByTagName(\"video\")[0]).muted = true"];
    [self.webView reload];
}


#pragma mark - 登录/退出登录 通知
- (void)loginNotification{
    
    NSString *requestURL = self.url.absoluteString;
    NSString *httpURL = [self addUserIdAndTokenWithURL:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpURL]];
    [self.webView loadRequest:request];
    self.isLogin = YES;
}

- (void)logoutNotification{
    
    NSString *requestURL = self.url.absoluteString;
    NSString *httpURL = [self addUserIdAndTokenWithURL:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpURL]];
    [self.webView loadRequest:request];
    self.isLogin = NO;
}

#pragma mark - URL添加userid logintoken
- (NSString *)addUserIdAndTokenWithURL:(NSString *)urlString{
    
    NSString *httpURL = @"";
    NSString *loginUserId = LOGIN_USERID.length >0 ? LOGIN_USERID : @"0";
    NSString *logintoken = [GlobalTool sharedTool].loginToken>0 ? [GlobalTool sharedTool].loginToken : @"";
    
    return httpURL;
}


- (NSString *)replacingUserIdAndTokenWithURL:(NSString *)urlString{

    NSString *baseURL = [[urlString componentsSeparatedByString:@"?"] firstObject];
    NSInteger i =0;
    NSString *loginUserId = LOGIN_USERID.length >0 ? LOGIN_USERID : @"0";
    NSString *logintoken = [GlobalTool sharedTool].loginToken>0 ? [GlobalTool sharedTool].loginToken : @"";
    NSString *httpURL = @"";
    return httpURL;
}



#pragma mark - 重新加载页面
-(void)refreshrWebView{
    
    [self.webView reload];
}

#pragma mark - 显示返回,分享按钮
- (void)seupTopButton{
    
    [self setBackButtonAction:@selector(webBackButtonAction)];
}

#pragma mark - 按钮事件
//返回按钮事件
- (void)webBackButtonAction{
    
    if(self.backURL.length>0){
        
        
        if([self.backURL isEqualToString:@"-1"]){
            
             [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
           
            HttpWebViewController *webVC = [[HttpWebViewController alloc] initWithURLString:self.backURL showTitle:YES];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
    }else{
       
        if(self.isGoRoot){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        else if([self.webView canGoBack]){
            
            if(self.isGoPrevious)
                [self.navigationController popViewControllerAnimated:YES];
            else
                [self.webView goBack];
        }else{
            [self.rt_navigationController popViewControllerAnimated:YES];
        }
        
        lastURL = nil;
    }
    
    
}

- (void)shareButtonAction{
    
    if([[GlobalTool sharedTool] isLoginAccount:self]){
        
        if (_defaultShareDic.count > 0) {
            
        }
        else
        {
            if(sharedDic){
                
                
                NSDictionary *dic = @{@"web":[sharedDic stringValueForKey:@"share_web"],@"wechat":[sharedDic stringValueForKey:@"share_wechat"]};
                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
            }
        }
        
        
    }

}


#pragma mark - 方法在子类中实现
- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request{
    return YES;
}




#pragma mark - 工具方法

/**
 *  执行JS匿名Function
 *
 *  @param function     匿名Function字符串
 *  @param arg          匿名Function传入参数
 *  @param context      JSContext对象用来执行匿名Function
 */
- (void)evalJSFunction:(NSString *)function
                   arg:(NSString *)arg
               context:(JSContext *)context{


    NSString *javaScrpitCommend = [NSString stringWithFormat:@"eval(%@)('%@')",function,arg];
    [context evaluateScript:javaScrpitCommend];


}

- (NSString *)trimWithString:(NSString *)str{
    
    NSString *string = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return string;
}


/**
 *  JSON字符串转换成NSDictionary
 *
 *  @param jsonStr JSON字符串
 *
 *  @return 转换后NSDictionary
 */
- (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr
{
    NSString *str = [self trimWithString:jsonStr];    
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return dic;
}

#pragma mark - 判断是否是本地离线文件
- (BOOL)fileExists:(NSString *)url{
    
//    NSString *fileName = [url stringByReplacingOccurrencesOfString:HttpBaseURL withString:[ZipManager HTMLPath]];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    BOOL res = [fileManager fileExistsAtPath:fileName];
//    
//    return res;
    return NO;
}



- (void)gotoNextViewWithURL:(NSString *)url{
    
    
}


#pragma mark - JSObjectProtocol


/**
 *  打开分享
 *
 *  @param shared 分享相关参数
 */
- (void)openShared:(JSValue *)value{
    
    if (_defaultShareDic.count == 0) {
        sharedDic = [self jsonStringToDictionary:[value toString]];
    }
    else
    {
        self.rightButton.enabled = YES;
    }
    
    if (sharedDic.count > 0) {
        self.rightButton.enabled = YES;
    }
    if([[sharedDic stringValueForKey:@"show"] isEqualToString:@"true"]){
        
        [self shareButtonAction];
    }
}


- (void)gotoBack:(JSValue *)value{
    
    NSDictionary *dic = [self jsonStringToDictionary:[value toString]];
    self.backURL= [dic objectForKey:@"url"];
}



/**
 *  打开二维码扫描页面
 *  本地有页面跳转效果
 *  @param value 扫描完成回调
 */
- (void)openScanView:(JSValue *)value{
        
    NSDictionary *param = [self jsonStringToDictionary:[value toString]];
    NSString *function = [param objectForKey:@"success"];
    
    
    if(![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            //打开二维码扫描页面
//            SMScanViewController *scanVC = [SMScanViewController new];
//            [scanVC setScanResultBlock:^(NSString *result) {
//                
//                if(result.length){
//                    
//                    //执行JS回调
//                    if(function.length){
//                        
//                        [self evalJSFunction:function arg:result context:value.context];
//                    }
//                    
//                }
//                
//            }];
//            [self.navigationController pushViewController:scanVC animated:YES];
        });
    }
    
   
    
    
    
}



/**
 *  打开一个网络页面
 *  本地有页面跳转效果
 *  @param value 网络链接
 */
- (void)openWebView:(JSValue *)value{
    
    NSDictionary *dic = [self jsonStringToDictionary:[value toString]];
    NSString *gotoUrl = [dic objectForKey:@"url"];
    
    if(![gotoUrl isEqualToString:lastURL]){
        
        if(![NSThread isMainThread])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self gotoNextViewWithURL:gotoUrl];
                
            });
            
        }else{
            
            [self gotoNextViewWithURL:gotoUrl];
            
        }

    }    
    
}


#pragma mark - 跳转登录

- (void)gotoLoginView{
    
//    if(![GlobalTool isLogin]){
        
        UIViewController *nextVC = nil;
        NSString *lastLoginId = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastLoginId"];
        
        
        
        dispatch_block_t cancelLoginBlcok = ^{
            
            //取消登录后作相关处理
            if([self.webView canGoBack]){
                
                [self.webView goBack];
            }
        };
}


@end
