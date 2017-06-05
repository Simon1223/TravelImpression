//
//  HttpRequestAPI.h
//  Speech
//
//  Created by Simon on 2017/5/18.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#ifndef HttpRequestAPI_h
#define HttpRequestAPI_h

//app id 1-用户端 2-商户端
#define AppTypeId @"1"

//IS_APPSTORE_VERSION  1====APPStore版本   0=====企业版本
#define IS_APPSTORE_VERSION  1

#define VersionChannel @"1" //版本渠道  //1-AppStore 版本 //2-Enterprise 企业版本

#define kResource @"ios"

//服务器地址 发布版本时注意切换服务器地址
//-----------------------------------------------------------------------------

//测试地址
//#define HttpRequestBaseURL @"http://test.didi365.com/api4/"
//#define kXMPPHost @"120.25.83.231"
//#define kChatDomain @"test.openfire.didi365.com"
//#define kHostURL @"http://srctest.didi365.com/didi365"
//#define kOpenfireSRCURL @"http://srctest.didi365.com/openfire"
//#define HttpBaseURL @"http://test.didi365.com/"




////正式地址
#define HttpRequestBaseURL @"http://api23.didi365.com/api4/"
#define kXMPPHost @"openfire.didi365.com"
#define kChatDomain @"openfire.didi365.com"
#define kHostURL    @"http://src.didi365.com/didi365"
#define kOpenfireSRCURL @"http://src.didi365.com/openfire"
#define HttpBaseURL @"http://api23.didi365.com/"

#endif /* HttpRequestAPI_h */
