//
//  HttpWebViewController.h
//  ShenMaDiDiClient
//
//  Created by DiDi365 on 15/10/30.
//  Copyright © 2015年 HengTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOWebViewController.h"


@interface HttpWebViewController : TOWebViewController
@property(nonatomic,assign) BOOL isGoRoot;
@property(nonatomic,assign) BOOL isGoPrevious;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,assign) BOOL refreshHide;

@property(nonatomic,strong) NSDictionary *defaultShareDic;

- (instancetype)initWithURLString:(NSString *)urlString
                        showTitle:(BOOL)showTitle;

- (instancetype)initWithPathString:(NSString *)pathString
                         showTitle:(BOOL)showTitle;


- (void)webBackButtonAction;
- (void)shareButtonAction;
- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request;
- (void)seupTopButton;

- (NSString *)addUserIdAndTokenWithURL:(NSString *)urlString ;

@end
