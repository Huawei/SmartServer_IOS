//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectIpVersionBlock)(NSString *value, NSInteger popRow);

@interface NetIpVersionChangePopView : UIControl
@property (assign, nonatomic) NSInteger popRow;
@property (copy, nonatomic) DidSelectIpVersionBlock didSelectIpVersionBlock;

- (void)reloadData;

@end
