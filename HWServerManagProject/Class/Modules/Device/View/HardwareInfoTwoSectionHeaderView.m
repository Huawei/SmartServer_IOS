//
//  HardwareInfoTwoSectionHeaderView.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/25.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoTwoSectionHeaderView.h"

@implementation HardwareInfoTwoSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ScreenWidth, 50);
    self.backgroundColor = RGBCOLOR(245, 242, 248);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
