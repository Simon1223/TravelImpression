//
//  HDScanningView.h
//
//  Created by SimonMBP on 14-8-21.
//  Copyright (c) 2014年 Simon All rights reserved.
//

#import "HDScanningView.h"

#define kXHQRCodeTipString @"将二维码放入框内，即可自动扫描"
#define kDevideRatio   DEVICE_WIDTH / 375
#define kXHQRCodeRectPaddingX 30 * kDevideRatio

@interface HDScanningView()

@property(nonatomic,strong) UIImageView *scanningImageView;
@property(nonatomic,assign) CGRect clearRect;
@property(nonatomic,strong) UILabel *QRCodeTipLabel;

@end

@implementation HDScanningView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        self.clearRect = CGRectMake(kXHQRCodeRectPaddingX, 120, CGRectGetWidth(frame) - kXHQRCodeRectPaddingX * 2, CGRectGetWidth(frame) - kXHQRCodeRectPaddingX * 2);

        [self addSubview:self.scanningImageView];
        [self addSubview:self.QRCodeTipLabel];
        [self startScanning];
    }
    return self;
}


#pragma mark - Propertys

- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {
        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXHQRCodeRectPaddingX, 160, CGRectGetWidth(self.bounds) - kXHQRCodeRectPaddingX * 2, 1.5)];
        _scanningImageView.backgroundColor = [UIColor clearColor];
        _scanningImageView.image = [UIImage imageNamed:@"saomiaoxian.png"];
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel {
    if (!_QRCodeTipLabel) {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.clearRect) + 30, CGRectGetWidth(self.bounds) - 40, 40)];
        _QRCodeTipLabel.text = kXHQRCodeTipString;
        _QRCodeTipLabel.numberOfLines = 0;
        _QRCodeTipLabel.textColor = [UIColor grayColor];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:15];
        _QRCodeTipLabel.tag = 222;
    }
    return _QRCodeTipLabel;
}


#pragma mark - 扫描线动画
- (void)startScanning {
    
    self.scanningImageView.frame = CGRectMake(kXHQRCodeRectPaddingX, 120, CGRectGetWidth(self.bounds) - kXHQRCodeRectPaddingX * 2, 1.5);
    CGRect animationRect = self.scanningImageView.frame;
    animationRect.origin.y += CGRectGetWidth(self.bounds) - CGRectGetMinX(animationRect) * 2 - CGRectGetHeight(animationRect);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:FLT_MAX];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    self.scanningImageView.hidden = NO;
    self.scanningImageView.frame = animationRect;
    [UIView commitAnimations];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGFloat tipLabelPadding = 30;
    CGFloat paddingX = kXHQRCodeRectPaddingX;
    CGRect clearRect = CGRectMake(paddingX, 120, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
    
    self.scanningImageView.hidden = YES;
    self.QRCodeTipLabel.text = kXHQRCodeTipString;
    self.scanningImageView.hidden = NO;
    
    self.clearRect = clearRect;
    
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.clearRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    
    CGContextClearRect(context, clearRect);
    
    CGContextSaveGState(context);
    
    UIImage *scanningBackImage = [UIImage imageNamed:@"erweimakuang.png"];
    
    [scanningBackImage drawInRect:CGRectMake(clearRect.origin.x-1, clearRect.origin.y-2, clearRect.size.width+2, clearRect.size.height+3)];

    
//    UIImage *topLeftImage = [UIImage imageNamed:@"ScanQR1"];
//    UIImage *topRightImage = [UIImage imageNamed:@"ScanQR2"];
//    UIImage *bottomLeftImage = [UIImage imageNamed:@"ScanQR3"];
//    UIImage *bottomRightImage = [UIImage imageNamed:@"ScanQR4"];
//    
//    [topLeftImage drawInRect:CGRectMake(clearRect.origin.x, clearRect.origin.y, topLeftImage.size.width, topLeftImage.size.height)];
//    
//    [topRightImage drawInRect:CGRectMake(CGRectGetMaxX(clearRect) - topRightImage.size.width, clearRect.origin.y, topRightImage.size.width, topRightImage.size.height)];
//    
//    [bottomLeftImage drawInRect:CGRectMake(clearRect.origin.x, CGRectGetMaxY(clearRect) - bottomLeftImage.size.height, bottomLeftImage.size.width, bottomLeftImage.size.height)];
//    
//    [bottomRightImage drawInRect:CGRectMake(CGRectGetMaxX(clearRect) - bottomRightImage.size.width, CGRectGetMaxY(clearRect) - bottomRightImage.size.height, bottomRightImage.size.width, bottomRightImage.size.height)];
    
//    CGFloat padding = 0.5;
//    CGContextMoveToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMinY(clearRect) - padding);
//    CGContextAddLineToPoint(context, CGRectGetMaxX(clearRect) + padding, CGRectGetMinY(clearRect) + padding);
//    CGContextAddLineToPoint(context, CGRectGetMaxX(clearRect) + padding, CGRectGetMaxY(clearRect) + padding);
//    CGContextAddLineToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMaxY(clearRect) + padding);
//    CGContextAddLineToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMinY(clearRect) - padding);
//    CGContextSetLineWidth(context, padding);
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextStrokePath(context);
}


@end
