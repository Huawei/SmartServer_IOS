//
//  GlobalData.h
//
//  Created by zhuxiang chen on 13-10-24.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"

@interface HWGlobalData : NSObject

@property (strong, nonatomic) UIColor *navColor;

@property (assign, nonatomic) BOOL whiteBGShow;

@property (copy, nonatomic) NSString *curDeviceIp;
@property (strong, atomic) DeviceModel *curDevice;

//@property (copy, atomic) NSString *curServiceItem;
@property (copy, atomic) NSString *XAuthToken;
@property (copy, atomic) NSString *ETag;
@property (copy, atomic) NSString *session_id;

@property (strong, nonatomic) NSMutableArray *deviceDataArray;
@property (strong, nonatomic) NSMutableArray *historyDeviceArray;

+ (HWGlobalData *)shared;

- (void)saveDevice:(DeviceModel *)device;
- (void)saveCurAllDevice;
- (void)changeDevice:(DeviceModel *)device;

- (void)getHistoryLookDevices;
- (void)deleteHistoryDevice:(DeviceModel *)device;
- (void)saveHistoryDevice:(DeviceModel *)device;
- (BOOL)haveForLocalHistoryDevice:(DeviceModel *)device;


@end
