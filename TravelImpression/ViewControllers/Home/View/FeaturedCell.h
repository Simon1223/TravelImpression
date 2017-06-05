//
//  FeaturedCell.h
//  Speech
//
//  Created by huadong on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedModel.h"


/**
 精选单元格
 */
@interface FeaturedCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(FeaturedModel *)model;

@end
