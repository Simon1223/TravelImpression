//
//  SMBannerSubiew.h
//  Created by Simon on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By Simon

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>

@interface SMBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 * 图片链接
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@end
