//
//  NoDeviceView.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/3.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, 250, 125);
    
    self.titleLabel.text = LocalString(@"listnorecord");
}

+ (NoDataView *)createFromBundle {
    NoDataView *view = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:nil options:nil] lastObject];
    return view;
}

@end
