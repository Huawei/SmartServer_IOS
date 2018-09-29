//
//  NoDeviceView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/3.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDeviceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (NoDeviceView *)createFromBundle;

@end
