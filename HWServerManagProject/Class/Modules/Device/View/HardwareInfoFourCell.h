//
//  HardwareInfoOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidHardwareInfoFourBlock)(NSString *count);


@interface HardwareInfoFourCell : UICollectionViewCell

@property (weak, nonatomic) UIViewController *controller;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidHardwareInfoFourBlock didHardwareInfoFourBlock;

@end
