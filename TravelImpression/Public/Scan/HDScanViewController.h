//
//  HDScanViewController.h
//
//  Created by SimonMBP on 14-8-21.
//  Copyright (c) 2014年 Simon All rights reserved.
//

#import "HDScanningView.h"
#import "EnterPassWordView.h"
#import "HDBaseViewController.h"
/**
 *  扫描界面
 */
@interface HDScanViewController : HDBaseViewController
{
    UIScrollView *scrolBack;
    UIView *_preview;
    HDScanningView *_sanningView;
    EnterPassWordView *_enterWordView;
    CGRect rectMake;
}

/**
 *  扫描完成之后的回调数据
 */
@property (nonatomic,copy)void (^smsFinishBlock)(NSString*number);

//车队id
@property (nonatomic, strong) NSString *carID;

@property (nonatomic, assign) BOOL isJoinCarTeam;

@end
