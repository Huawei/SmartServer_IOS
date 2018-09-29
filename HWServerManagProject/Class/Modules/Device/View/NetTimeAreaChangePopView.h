//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectTimeAreaBlock)(NSString *value, NSInteger popRow);

@interface NetTimeAreaChangePopView : UIControl

@property (assign, nonatomic) NSInteger popRow;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (copy, nonatomic) DidSelectTimeAreaBlock didSelectTimeAreaBlock;

- (void)reloadData;

@end
