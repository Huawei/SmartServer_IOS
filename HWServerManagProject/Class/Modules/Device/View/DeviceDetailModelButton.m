//
//  DeviceDetailModelButton.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/26.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceDetailModelButton.h"

@implementation DeviceDetailModelButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countLabel.layer.cornerRadius = 9.5;
    self.countLabel.layer.masksToBounds = YES;
}

@end
