//
//  DeviceDetailChangePopView.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectNetPortModelBlock)(NSString *value);

@interface NetPortModelChangePopView : UIControl

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidSelectNetPortModelBlock didSelectNetPortModelBlock;

- (void)reloadData;

@end
