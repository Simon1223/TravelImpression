//
//  ISRDataHander.m
//  MSC
//
//  Created by ypzhao on 12-11-19.
//  Copyright (c) 2012年 iflytek. All rights reserved.
//

#import "ISRDataHelper.h"

@implementation ISRDataHelper

/**
 解析命令词返回的结果
 ****/
+ (NSString*)stringFromAsr:(NSString*)params;
{
    NSMutableString * resultString = [[NSMutableString alloc]init];
    NSString *inputString = nil;
    
    NSArray *array = [params componentsSeparatedByString:@"\n"];
    
    for (int  index = 0; index < array.count; index++)
    {
        NSRange range;
        NSString *line = [array objectAtIndex:index];
        
        NSRange idRange = [line rangeOfString:@"id="];
        NSRange nameRange = [line rangeOfString:@"name="];
        NSRange confidenceRange = [line rangeOfString:@"confidence="];
        NSRange grammarRange = [line rangeOfString:@" grammar="];
        
        NSRange inputRange = [line rangeOfString:@"input="];
        
        if (confidenceRange.length == 0 || grammarRange.length == 0 || inputRange.length == 0 )
        {
            continue;
        }
        
        //check nomatch
        if (idRange.length!=0) {
            NSUInteger idPosX = idRange.location + idRange.length;
            NSUInteger idLength = nameRange.location - idPosX;
            range = NSMakeRange(idPosX,idLength);
            NSString *idValue = [[line substringWithRange:range]
                                 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet] ];
            if ([idValue isEqualToString:@"nomatch"]) {
                return @"";
            }
        }
        
        //Get Confidence Value
        NSUInteger confidencePosX = confidenceRange.location + confidenceRange.length;
        NSUInteger confidenceLength = grammarRange.location - confidencePosX;
        range = NSMakeRange(confidencePosX,confidenceLength);
        
        
        NSString *score = [line substringWithRange:range];
        
        NSUInteger inputStringPosX = inputRange.location + inputRange.length;
        NSUInteger inputStringLength = line.length - inputStringPosX;
        
        range = NSMakeRange(inputStringPosX , inputStringLength);
        inputString = [line substringWithRange:range];
        
        [resultString appendFormat:@"%@ 置信度%@\n",inputString, score];
    }
    
    return resultString;
    
}

/**
 解析听写json格式的数据
 params例如：
 {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 ****/
+ (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];

    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}


/**
 解析语法识别返回的结果
 ****/
+ (NSString *)stringFromABNFJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSArray *wordArray = [resultDic objectForKey:@"ws"];
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                NSString *score = [wDic objectForKey:@"sc"];
                [tempStr appendString: str];
                [tempStr appendFormat:@" 置信度:%@",score];
                [tempStr appendString: @"\n"];
            }
        }
    return tempStr;
}

/**
 解析语义理解返回的结果
 ****/

/*
 -------------------------------------------
 **问答
 {
 "rc":0,
 "operation":"ANSWER",
 "service":"datetime",
 "answer":{
 "text":"今天是2017年05月06日 丁酉年四月十一 星期六",
 "type":"T"
 },
 "text":"认为今天星期几？"
 }
 
 --------------------------------------------
 **打开APP
 {
 "semantic":{
 "slots":{
 "name":"qq音乐"
 }
 },
 "rc":0,
 "operation":"LAUNCH",
 "service":"app",
 "moreResults":Array[1],
 "text":"打开QQ音乐。"
 }
 
 ---------------------------------------------
 **打电话
 {
 "semantic":{
 "slots":{
 "name":"刘宝春"
 }
 },
 "rc":0,
 "operation":"CALL",
 "service":"telephone",
 "text":"呼叫刘宝春。"
 }
 
 ---------------------------------------------
 **导航
 {
 "semantic":{
 "slots":{
 "endLoc":{
 "type":"LOC_POI",
 "poi":"深圳北站",
 "city":"深圳市",
 "cityAddr":"深圳"
 },
 "startLoc":{
 "type":"LOC_POI",
 "city":"CURRENT_CITY",
 "poi":"CURRENT_POI"
 }
 }
 },
 "rc":0,
 "operation":"ROUTE",
 "service":"map",
 "text":"导航到深圳北站。"
 }
 
 ---------------------------------------------------
 **天气
 {
 "webPage":Object{...},
 "semantic":{
 "slots":{
 "location":Object{...},
 "datetime":{
 "date":"2017-05-07",
 "type":"DT_BASIC",
 "dateOrig":"明天"
 }
 }
 },
 "rc":0,
 "operation":"QUERY",
 "service":"weather",
 "data":{
 "result":[
 Object{...},
 {
 "dateLong":1494086400,
 "sourceName":"中国天气网",
 "date":"2017-05-07",
 "lastUpdateTime":"2017-05-06 15:02:06",
 "city":"深圳",
 "windLevel":0,
 "weather":"阵雨",
 "tempRange":"23℃~28℃",
 "wind":"无持续风向微风"
 },
 Object{...},
 Object{...},
 Object{...},
 Object{...},
 Object{...}
 ]
 },
 "text":"明天天气怎么样?"
 }
 
 */

/*
 key: operation--操作，service--服务 ，send--发送的消息 ，get--收到的消息 ，appName--打开的App ，route--导航信息 ，callName--打给谁 ，music--音乐
 */

+ (NSDictionary *)DictionaryFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    [dic setObject:[resultDic objectForKey:@"text"] forKey:@"send"];
    if ([[resultDic objectForKey:@"rc"] integerValue] == 0) {
        [dic setObject:[resultDic objectForKey:@"operation"] forKey:@"operation"];
        [dic setObject:[resultDic objectForKey:@"service"] forKey:@"service"];
    }
    else
    {
        [dic setObject:@"ANSWER" forKey:@"operation"];
        NSArray *arr = @[@"给老婆打电话",@"呼叫10086",@"导航去深圳北站",@"打开QQ音乐",@"明天天气怎么样"];
        int i = arc4random()%(arr.count);
        [dic setObject:[NSString stringWithFormat:@"我不明白您想说什么，请说‘%@’",arr[i]] forKey:@"get"];
    }
    
    
    if ([[resultDic objectForKey:@"operation"] isEqualToString:@"ANSWER"]) {
        //问答
        [dic setObject:[[resultDic objectForKey:@"answer"] objectForKey:@"text"] forKey:@"get"];
    }
    else if ([[resultDic objectForKey:@"operation"] isEqualToString:@"LAUNCH"])
    {
        //打开APP
        [dic setObject:[[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"name"]forKey:@"appName"];
    }
    else if ([[resultDic objectForKey:@"operation"] isEqualToString:@"ROUTE"])
    {
        //导航
        [dic setObject:[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] forKey:@"route"];
    }
    else if ([[resultDic objectForKey:@"operation"] isEqualToString:@"CALL"])
    {
        //打电话
        if ([[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"name"])
        {
            [dic setObject:[[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"name"]forKey:@"callName"];
        }
        else if ([[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"code"])
        {
            [dic setObject:[[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"code"] forKey:@"callName"];
        }
    }
    else if ([[resultDic objectForKey:@"operation"] isEqualToString:@"QUERY"])
    {
        if ([[resultDic objectForKey:@"service"] isEqualToString:@"weather"]) {
           //天气
            NSString *date = [[[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"datetime"] objectForKey:@"date"];
            NSString *sayDate = [[[[resultDic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"datetime"] objectForKey:@"dateOrig"];
            
            NSDictionary *weatherDic = nil;
            NSArray *result = [[resultDic objectForKey:@"data"] objectForKey:@"result"];
            
            if ([date isEqualToString:@"CURRENT_DAY"]) {
                weatherDic = result[0];
            }
            else
            {
                for (NSDictionary *resultDic in result) {
                    if ([[resultDic objectForKey:@"date"] isEqualToString:date]) {
                        weatherDic = resultDic;
                        break;
                    }
                }
            }
            
            NSString *resultString = @"暂无天气信息";
            if (weatherDic) {
                resultString = [NSString stringWithFormat:@"%@%@%@,%@,%@",[weatherDic objectForKey:@"city"],sayDate?:@"",[weatherDic objectForKey:@"weather"],[weatherDic objectForKey:@"wind"],[weatherDic objectForKey:@"tempRange"]];
            }
            
            [dic setObject:resultString forKey:@"get"];
        }
    }
    else if ([[resultDic objectForKey:@"operation"] isEqualToString:@"PLAY"])
    {
        if ([[resultDic objectForKey:@"service"] isEqualToString:@"music"]) {
            //播放音乐
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"result"] forKey:@"music"];
        }
    }
    return dic;
}

@end
