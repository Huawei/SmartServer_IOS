//
//  DeviceModel.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/27.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject<NSCoding>


@property (copy, nonatomic) NSString *curServiceItem;//接口对象

@property (copy, nonatomic) NSString *connectType;//接入方式
@property (copy, nonatomic) NSString *deviceName;//IP名/主机名
@property (copy, nonatomic) NSString *port;//端口
@property (copy, nonatomic) NSString *otherName;//别名
@property (copy, nonatomic) NSString *account;//用户
@property (copy, nonatomic) NSString *password;//密码
@property (copy, nonatomic) NSString *domain;//域
@property (copy, nonatomic) NSString *serialNumber;//域
@property (assign, nonatomic) BOOL isKeepPwd;//记住密码
@property (assign, nonatomic) NSInteger timeSp;//存储时间戳



@end
