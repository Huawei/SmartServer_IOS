//
//  PowerSwitchViewController.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidControlCompleteBlock)(NSString *powerStateStr);

@interface PowerSwitchViewController : UITableViewController

@property (copy, nonatomic) NSString *powerStateStr;
@property (copy, nonatomic) DidControlCompleteBlock didControlCompleteBlock;

@end
