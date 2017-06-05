//
//  FeaturedDetailHeaderView.m
//  Speech
//
//  Created by huadong on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "FeaturedDetailHeaderView.h"
#import "FeaturedModel.h"

@implementation FeaturedDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame model:(FeaturedModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    
    return self;
}

@end
