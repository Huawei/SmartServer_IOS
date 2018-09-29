//
//  HealthEventsCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HealthEventsOneCell.h"

@implementation HealthEventsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowdown"] forState:UIControlStateNormal];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowdown"] forState:UIControlStateHighlighted];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowup"] forState:UIControlStateSelected];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowup"] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
