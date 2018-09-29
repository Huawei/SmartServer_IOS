//
//  FilterControl.m
//  market
//
//  Created by xunruiIOS on 2018/2/2.
//  Copyright © 2018年 xunruiIos. All rights reserved.
//

#import "FilterControl.h"

@interface FilterControl()

@property (strong, nonatomic) UIImageView *iconIMV;

@end


@implementation FilterControl


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withIsArrow:(BOOL)isArrow {
    self = [super initWithFrame:frame];
    if (self) {
        if (isArrow) {
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [self addSubview:self.titleLabel];
//            self.titleLabel.userInteractionEnabled = YES;
            self.titleLabel.textColor = HEXCOLOR(0x333333);
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.text = title;
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).offset(-5.5);
                make.centerY.equalTo(self);
                make.width.lessThanOrEqualTo(@(frame.size.width - 11));
            }];
            self.iconIMV = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:self.iconIMV];
//            self.iconIMV.userInteractionEnabled = YES;
            self.iconIMV.contentMode = UIViewContentModeScaleAspectFit;
            __weak typeof(self) weakSelf = self;
            [self.iconIMV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.titleLabel.mas_right).offset(4);
                make.centerY.equalTo(self);
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(14);
            }];
//            self.iconIMV.userInteractionEnabled = YES;
            self.iconIMV.image = [UIImage imageNamed:@"one_cellarrowdownicon"];
        } else {
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [self addSubview:self.titleLabel];
//            self.titleLabel.userInteractionEnabled = YES;
            self.titleLabel.textColor = HEXCOLOR(0x171717);
            self.titleLabel.font = [UIFont systemFontOfSize:13];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.text = title;
//            self.titleLabel.userInteractionEnabled = YES;
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self);
                make.width.lessThanOrEqualTo(self);
            }];
            
        }
    }
    return self;
}

- (void)setIsDidSelected:(BOOL)isDidSelected {
    _isDidSelected = isDidSelected;
    if (isDidSelected) {
        self.titleLabel.textColor = HEXCOLOR(0xFA4949);
    } else {
        self.titleLabel.textColor = HEXCOLOR(0x171717);
    }
}

@end
