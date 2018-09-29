//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectSysLogTimeBlock)(NSString *sTime,NSString *eTime);

@interface SysLogTimeSelectPopView : UIControl

@property (weak, nonatomic) IBOutlet UIDatePicker *startPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endPicker;

@property (copy, nonatomic) DidSelectSysLogTimeBlock didSelectSysLogTimeBlock;



@end
