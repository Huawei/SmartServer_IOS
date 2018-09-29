//
//  NoDeviceView.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/3.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NoDeviceView.h"

@implementation NoDeviceView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, 160, 125);
    self.titleLabel.text = LocalString(@"nodeviceaddalert");
}

+ (NoDeviceView *)createFromBundle {
    NoDeviceView *view = [[[NSBundle mainBundle] loadNibNamed:@"NoDeviceView" owner:nil options:nil] lastObject];
    return view;
}

@end
