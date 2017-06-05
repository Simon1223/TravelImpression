//
//  TankCycleScrollView.h
//  TankCarouselFigure
//
//  Created by yanwb on 15/12/23.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Control.h"

typedef enum {
    HDParallaxPageContolAlimentRight, //右下方
    HDParallaxPageContolAlimentCenter //中下方
} HDParallaxPageContolAliment;


@interface HDParallaxHeaderView : UIView
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration openTimer:(BOOL)open;


/**
 *  用于下拉图片放大效果
 *
 *  @param offset             offset
 */
- (void)parallaxHeaderViewStretchingWithOffset:(CGFloat)offset;


/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);
@property (nonatomic , copy) void (^ScrollIndexBlock)(NSInteger pageIndex);

#pragma mark - require
//图片数组
@property (nonatomic, strong) NSArray *parallaxImageArray;

//图片路径数组
@property (nonatomic, strong) NSArray *parallaxImageUrlArray;

#pragma mark - optional

//预防点击做一些动作 增添这个属性  应与图片数组的数量一致并且一一对应
@property (nonatomic, strong) NSArray *modelArray;

//设定加载失败次数(范围内尝试重新加载)
@property (nonatomic, assign) NSInteger networkFailedCount;

//是否显示pageControl   默认显示
@property(nonatomic, assign) BOOL showPageControl;

//pageControl显示位置
@property (nonatomic, assign) HDParallaxPageContolAliment parallaxPageControlAliment;

//pageControl当前颜色
@property (nonatomic, strong) UIColor *parallaxCurrentPageIndicatorTintColor;

//pageControl平常颜色
@property (nonatomic, strong) UIColor *parallaxPageIndicatorTintColor;

//是否允许拉伸效果  默认无效果
@property (nonatomic, assign) BOOL enbleStretch;

//是否模糊处理
@property (nonatomic, assign) BOOL isBlur;

//模糊等级（0-100，默认10）
@property (nonatomic, assign) int blurLevel;

@end
