//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectTimeArea2Block)(id model);

@interface NetTimeAreaChange2PopView : UIControl

@property (strong, nonatomic) NSDictionary *dataDic;
@property (copy, nonatomic) DidSelectTimeArea2Block didSelectTimeArea2Block;

- (void)reloadData;

@end
