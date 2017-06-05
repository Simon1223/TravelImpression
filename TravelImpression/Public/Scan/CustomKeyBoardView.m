//
//  CustomKeyBoardView.m
//  SMDD
//
//  Created by CongHe on 16/12/30.
//  Copyright © 2016年 DianDi. All rights reserved.
//

#import "CustomKeyBoardView.h"

@implementation CustomKeyBoardView
{
    NSMutableString * inputString;
    float _duration;
    CGRect keyBoardRect;
    BOOL _animated;
    UIView * _superView;
    void(^_touchBlcok)(NSString * string);
    
}

- (id)initWithFrame:(CGRect)frame
          SuperView:(UIView *)superview
              Block:(void(^)(NSString * string))block
{
    if (self = [super initWithFrame:frame]) {
        _superView = superview;
        _touchBlcok = block;
        self.backgroundColor = [UIColor blackColor];
    }
    [self creatKeyBoard];
    return self;
}

-(void)creatKeyBoard{
    float space = 1.f;
    float width = (DEVICE_WIDTH - 2 * space)/3;
    float heigh = 69.f * DEVICE_WIDTH/375;  //以375屏幕为参照
    if (DEVICE_HEIGHT == 480) {
        heigh = 38.f;
    }
    
    keyBoardRect = CGRectMake(0, 0, DEVICE_WIDTH, heigh * 4 + 3 *space);
    UIView * bgView = [[UIView alloc]initWithFrame:keyBoardRect];
    for (int i = 0;  i< 12; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor grayColor]];
        button.frame = CGRectMake(i%3 *(width + space), i/3 *(heigh + space), width, heigh);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        if (i < 9) {
            [button setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateDisabled];
        }else if(i == 10){
            [button setTitle:@"0" forState:UIControlStateNormal];
            [button setTitle:@"0" forState:UIControlStateDisabled];
        }else if(i == 11){
            [button setImage:[UIImage imageNamed:@"key_shanchu"] forState:UIControlStateNormal];
            [button setTitle:@"<-" forState:UIControlStateDisabled];
        }else{
            button.enabled = NO;
        }
        [bgView addSubview:button];
    }
    [self addSubview:bgView];
    self.frame = CGRectMake(0, self.superview.bounds.size.height, keyBoardRect.size.width, keyBoardRect.size.height);
}

-(void)buttonTouch:(UIButton*)sender{
    
    NSString * str = [sender titleForState:UIControlStateDisabled];
    NSLog(@"点击了%@",str);
    if ([str isEqualToString:@"<-"]) {
        
        if (inputString.length) {
            [inputString deleteCharactersInRange:NSMakeRange(inputString.length-1, 1)];
        }
        
    }else{
        
        if(inputString.length < 6){
            [inputString appendString:str];
        }
    }
    if (_touchBlcok) {
        _touchBlcok(inputString);
    }
}

- (void)cleanInputString
{
    inputString = [NSMutableString string];
}

-(void)showWithAnimate:(BOOL)animate Duration:(float)duration{
    _duration = duration;
    _animated = animate;
    inputString = [NSMutableString string];
    self.userInteractionEnabled = NO;
    [_superView addSubview:self];
    [UIView animateWithDuration:_animated?_duration:0.f animations:^{
        self.frame = CGRectMake(0, _superView.bounds.size.height - keyBoardRect.size.height -64, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

-(void)dismiss{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:_animated?_duration:0.f animations:^{
        self.frame = CGRectMake(0, self.superview.bounds.size.height -64, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
- (void)dealloc
{
    
}

@end
