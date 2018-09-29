//
//  NetSettingOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidRefreshPowerSwitcBlock)(NSDictionary *data, NSString *odata_id);

@interface PowerSwitchMainTwoCell : UICollectionViewCell

@property (strong, nonatomic) NSNumber *safePowerOffTimoutSeconds;
@property (strong, nonatomic) IBOutlet UITextField *inputTF;
@property (copy, nonatomic) NSString *odata_id;

@property (copy, nonatomic) DidRefreshPowerSwitcBlock didRefreshPowerSwitcBlock;

@end
