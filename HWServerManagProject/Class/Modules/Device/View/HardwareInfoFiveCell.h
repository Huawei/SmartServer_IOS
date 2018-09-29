//
//  HardwareInfoOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DidHardwareInfoFiveBlock)(NSString *count);
typedef void(^DidHardwareLogicalDriveBlock)(NSDictionary *value);
typedef void(^DidHardwareDriveBlock)(NSDictionary *value);

@interface HardwareInfoFiveCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidHardwareInfoFiveBlock didHardwareInfoFiveBlock;
@property (copy, nonatomic) DidHardwareLogicalDriveBlock didHardwareLogicalDriveBlock;
@property (copy, nonatomic) DidHardwareDriveBlock didHardwareDriveBlock;

@end
