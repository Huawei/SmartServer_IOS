//
//  AddDeviceViewController.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWBaseViewController.h"

typedef void(^DidRealTimeStatusBlock)(void);

@interface RealTimeStatusViewController : UITableViewController

@property (strong, nonatomic) NSArray *temperatures;

@property (strong, nonatomic) NSMutableArray *healthContentArray;
@property (copy, nonatomic) DidRealTimeStatusBlock didRealTimeStatusBlock;


@end
