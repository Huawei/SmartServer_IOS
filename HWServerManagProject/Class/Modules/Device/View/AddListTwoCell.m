//
//  AddListTwoCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "AddListTwoCell.h"

@implementation AddListTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.onOffSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.onOffSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

}
- (void)switchAction:(UISwitch *)sender {
    if (self.didChangeStatusBlock) {
        self.didChangeStatusBlock(sender.on);
    }
    if (self.didChangeStatusIndexBlock) {
        self.didChangeStatusIndexBlock(sender.on, self.row);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
