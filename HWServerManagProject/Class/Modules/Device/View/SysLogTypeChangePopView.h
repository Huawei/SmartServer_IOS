//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectSysLogTypeValuBlock)(NSString *value);

@interface SysLogTypeChangePopView : UIControl

@property (copy, nonatomic) NSString *secTitle;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidSelectSysLogTypeValuBlock didSelectSysLogTypeValuBlock;

- (void)reloadData;

@end
