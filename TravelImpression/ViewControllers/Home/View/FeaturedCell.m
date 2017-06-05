//
//  FeaturedCell.m
//  Speech
//
//  Created by huadong on 2017/5/23.
//  Copyright © 2017年 Simon.H. All rights reserved.
//

#import "FeaturedCell.h"

@interface FeaturedCell ()

@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIImageView *backImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *addressButton;
@property (nonatomic, weak) IBOutlet UIImageView *userHeaderImageView;

@end

@implementation FeaturedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(FeaturedModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.backView.backgroundColor = [UIColor lightGrayColor];
        self.backView.layer.cornerRadius = 4;
        self.backView.clipsToBounds = YES;
        self.userHeaderImageView.layer.cornerRadius = 16;
        self.userHeaderImageView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.2].CGColor;
        self.userHeaderImageView.layer.borderWidth = 2;
        self.userHeaderImageView.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
