//
//  DeviceDetailListCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceDetailListTwoCell.h"

@implementation DeviceDetailListTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconIMV.userInteractionEnabled = YES;
    [self.iconIMV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHealthAction)]];
}

- (void)toHealthAction {
    if (self.didToHealthCellBlock) {
        self.didToHealthCellBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
