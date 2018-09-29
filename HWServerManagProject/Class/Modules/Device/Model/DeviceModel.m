//
//  DeviceModel.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/27.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel


- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    if (self.connectType) {
        [aCoder encodeObject:self.connectType forKey:@"connectType"];
    }
    if (self.curServiceItem) {
        [aCoder encodeObject:self.curServiceItem forKey:@"curServiceItem"];
    }
    if (self.deviceName) {
        [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    }
    if (self.port) {
        [aCoder encodeObject:self.port forKey:@"port"];
    }
    if (self.otherName) {
        [aCoder encodeObject:self.otherName forKey:@"otherName"];
    }
    if (self.account) {
        [aCoder encodeObject:self.account forKey:@"account"];
    }
    if (self.password) {
        [aCoder encodeObject:self.password forKey:@"password"];
    }
    if (self.domain) {
        [aCoder encodeObject:self.domain forKey:@"domain"];
    }

    if (self.serialNumber) {
        [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    }
    if (self.timeSp) {
        [aCoder encodeInteger:self.timeSp forKey:@"timeSp"];
    }
    [aCoder encodeBool:self.isKeepPwd forKey:@"isKeepPwd"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        
        self.curServiceItem = [aDecoder decodeObjectForKey:@"curServiceItem"];
        self.connectType = [aDecoder decodeObjectForKey:@"connectType"];
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.port = [aDecoder decodeObjectForKey:@"port"];
        self.otherName = [aDecoder decodeObjectForKey:@"otherName"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.domain = [aDecoder decodeObjectForKey:@"domain"];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.isKeepPwd = [aDecoder decodeBoolForKey:@"isKeepPwd"];
        self.timeSp = [aDecoder decodeIntegerForKey:@"timeSp"];
        if (!self.curServiceItem) {
            self.curServiceItem = @"1";
        }

    }
    return self;
}



@end
