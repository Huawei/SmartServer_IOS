//
//  FilterControl.h
//  market
//
//  Created by xunruiIOS on 2018/2/2.
//  Copyright © 2018年 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterControl : UIControl

@property (assign, nonatomic) BOOL isDidSelected;
@property (strong, nonatomic) UILabel *titleLabel;


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withIsArrow:(BOOL)isArrow;

@end
