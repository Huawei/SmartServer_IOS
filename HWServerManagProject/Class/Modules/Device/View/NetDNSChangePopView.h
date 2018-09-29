//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelecDNSBlock)(NSString *value, NSInteger popRow);

@interface NetDNSChangePopView : UIControl

@property (assign, nonatomic) BOOL hasipv4;
@property (assign, nonatomic) BOOL hasipv6;

@property (assign, nonatomic) NSInteger popRow;
@property (copy, nonatomic) DidSelecDNSBlock didSelecDNSBlock;

- (void)reloadData;

@end
