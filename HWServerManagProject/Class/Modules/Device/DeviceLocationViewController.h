//
//  DeviceLocationViewController.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangeLocationBlock)(NSString *devicelocation);

@interface DeviceLocationViewController : UITableViewController

@property (copy, nonatomic) NSString *devicelocation;
@property (copy, nonatomic) DidChangeLocationBlock didChangeLocationBlock;

@end
