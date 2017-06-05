//
//  CustomKeyBoardView.h
//  SMDD
//
//  Created by CongHe on 16/12/30.
//  Copyright © 2016年 DianDi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomKeyBoardView : UIView

- (id)initWithFrame:(CGRect)frame
          SuperView:(UIView *)superview
              Block:(void(^)(NSString * string))block;

-(void)showWithAnimate:(BOOL)animate Duration:(float)duration;

-(void)dismiss;

- (void)cleanInputString;

@end
