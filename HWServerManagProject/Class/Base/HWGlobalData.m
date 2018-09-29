//
//  GlobalData.m
//
//  Created by zhuxiang chen on 13-10-24.
//

#import "HWGlobalData.h"

@implementation HWGlobalData
@synthesize curDevice =_curDevice;

static HWGlobalData  * instance = nil;

+ (instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
//        instance.curServiceItem = @"1";
//        instance.XAuthToken = @"";
    }) ;
    return instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    return   [HWGlobalData shared];
    
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    
    return  [HWGlobalData shared];
    
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
    }
    
    return  self;
}

- (DeviceModel *)curDevice {
    if (_curDevice != nil) {
        return _curDevice;
    }

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSData * data1 = [userdefaults objectForKey:@"localCurDevice"];
    [userdefaults synchronize];
    if (data1 == nil) {
        _curDevice = nil;
        return _curDevice;
    }
    _curDevice = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    return _curDevice;
}

- (void)setCurDevice:(DeviceModel *)curDevice {
    _curDevice = curDevice;
    if (curDevice == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"localCurDevice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSData * data1  = [NSKeyedArchiver archivedDataWithRootObject:curDevice];
        [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"localCurDevice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (NSString *)XAuthToken {
    NSString *tempvalue = [[NSUserDefaults standardUserDefaults] objectForKey:@"localXAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (tempvalue == nil) {
        return @"";
    }
    return tempvalue;
}

- (void)setXAuthToken:(NSString *)XAuthToken {
    if (XAuthToken == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"localXAuthToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:XAuthToken forKey:@"localXAuthToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)session_id {
    NSString *tempvalue = [[NSUserDefaults standardUserDefaults] objectForKey:@"localsession_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return tempvalue;
}

- (void)setSession_id:(NSString *)session_id {
    if (session_id == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"localsession_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:session_id forKey:@"localsession_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSMutableArray *)deviceDataArray {
    if (!_deviceDataArray) {
        _deviceDataArray = [NSMutableArray new];
        NSData * data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceDataLocal"];
        NSArray *data = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
        if (data && [data isKindOfClass:[NSArray class]]) {
            [_deviceDataArray addObjectsFromArray:data];
        }
        
    }
    return _deviceDataArray;
}

- (void)saveDevice:(DeviceModel *)device {
    [self.deviceDataArray addObject:device];
    NSData * data1  = [NSKeyedArchiver archivedDataWithRootObject:self.deviceDataArray];
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"DeviceDataLocal"];
    
}

- (void)changeDevice:(DeviceModel *)device {
    
    for (DeviceModel *model in self.deviceDataArray) {
        if (model.timeSp == device.timeSp) {
            model.deviceName = device.deviceName;
            model.otherName = device.otherName;
            model.port = device.port;
            model.account = device.account;
            model.password = device.password;
            model.isKeepPwd = device.isKeepPwd;
            NSData * data1  = [NSKeyedArchiver archivedDataWithRootObject:self.deviceDataArray];
            [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"DeviceDataLocal"];
            
            break;
        }
    }
    
}

- (void)saveCurAllDevice {
    NSData * data1  = [NSKeyedArchiver archivedDataWithRootObject:self.deviceDataArray];
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"DeviceDataLocal"];
}

- (void)getHistoryLookDevices {
    NSMutableArray *hisotrys = [NSMutableArray new];
    NSData * data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceHistoryLookDataLocal"];
    NSArray *data = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    if (data && [data isKindOfClass:[NSArray class]]) {
        [hisotrys addObjectsFromArray:data];
    }
    self.historyDeviceArray = hisotrys;
}
- (void)deleteHistoryDevice:(DeviceModel *)device {
    for (DeviceModel *model in self.historyDeviceArray) {
        if (model.timeSp == device.timeSp) {
            [self.historyDeviceArray removeObject:model];
            NSData * data1  = [NSKeyedArchiver archivedDataWithRootObject:self.historyDeviceArray];
            [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"DeviceHistoryLookDataLocal"];
            break;
        }
    }
}

- (void)saveHistoryDevice:(DeviceModel *)device {
    BOOL isHave = NO;
    for (DeviceModel *model in self.historyDeviceArray) {
        if (model.timeSp == device.timeSp) {
            isHave = YES;
            break;
        }
    }
    if (!isHave) {
        [self.historyDeviceArray addObject:device];
        NSData * data1  = [NSKeyedArchiver archivedDataWithRootObject:self.historyDeviceArray];
        [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"DeviceHistoryLookDataLocal"];
    }
}

- (BOOL)haveForLocalHistoryDevice:(DeviceModel *)device {
    BOOL isHave = NO;
    for (DeviceModel *model in self.historyDeviceArray) {
        if (model.timeSp == device.timeSp) {
            isHave = YES;
            break;
        }
    }
    return isHave;
}



@end
