//
//  DeviceListCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceListTwoCell.h"

@implementation DeviceListTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
