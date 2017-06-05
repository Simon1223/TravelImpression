//
//  HDTabBar.m
//  Speech
//
//  Created by huadong on 2017/5/18.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "HDTabBar.h"

@interface HDTabBar ()

@property (nonatomic, copy) UIView *centerView;
@property (nonatomic, copy) UIButton *centerButton;

@end

#define itemWidth [UIScreen mainScreen].bounds.size.width * 0.2
#define TabBarHeight 49
#define centerRadius 20
#define CenterTitle @"发布"

@implementation HDTabBar

- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*2, 0, itemWidth, 49)];
        _centerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_centerView];
    }
    
    return _centerView;
}

- (UIButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerButton.frame = CGRectMake(0, 0, centerRadius*2, centerRadius*2);
        [_centerButton setImage:[UIImage imageNamed:@"tabbar_plus"] forState:UIControlStateNormal];
        [_centerButton setImage:[UIImage imageNamed:@"tabbar_plus"] forState:UIControlStateSelected];
        [_centerButton setAdjustsImageWhenHighlighted:NO];
        [_centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerButton];
    }
    
    return _centerButton;
}

- (void)layoutSubviews
{
    int index = 0;
    [super layoutSubviews];
    
    for (int i = 0; i<self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGRect rect = view.frame;
            rect.size.width = itemWidth;
            rect.size.height = self.frame.size.height;
            rect.origin.y = 0;
            
            if (index < 2) {
                rect.origin.x = index*itemWidth;
            }
            else if (index>=2)
            {
                rect.origin.x = index*itemWidth + itemWidth;
            }
            
            view.frame = rect;
            index++;
        }
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //中间按钮
    self.centerView.center = CGPointMake(width/2, 24.5);
    self.centerButton.center = CGPointMake(width/2, 24.5);
}

- (void)centerButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            sender.transform = CGAffineTransformMakeRotation (M_PI_4);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            sender.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    
    if (self.HDTabBardelegate && [self.HDTabBardelegate respondsToSelector:@selector(centerButtonClick:)]) {
        [self.HDTabBardelegate centerButtonClick:sender];
    }
}

- (void)closeCenterButton
{
    if (self.centerButton.selected) { 
        [UIView animateWithDuration:0.25 animations:^{
            self.centerButton.transform = CGAffineTransformMakeRotation(0);
            self.centerButton.selected = NO;
        }];
    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self.centerView setHidden:hidden];
    [self.centerButton setHidden:hidden];
}

@end
