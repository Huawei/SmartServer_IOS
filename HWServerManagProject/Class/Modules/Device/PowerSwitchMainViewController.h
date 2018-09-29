//
//  PowerSwitchMainViewController.h
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/16.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWBaseViewController.h"

typedef void(^DidControlMainCompleteBlock)(NSString *powerStateStr);

@interface PowerSwitchMainViewController : HWBaseViewController

@property (copy, nonatomic) NSString *powerStateStr;
@property (copy, nonatomic) DidControlMainCompleteBlock didControlMainCompleteBlock;

@end
