//
//  NetSettingTwoSubCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingTwoSubCell.h"

@implementation NetSettingTwoSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    if (isChecked) {
        self.iconIMV.image = [UIImage imageNamed:@"one_checkCirSelectedIcon"];
    } else {
        self.iconIMV.image = [UIImage imageNamed:@"one_checkCirNormalIcon"];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
