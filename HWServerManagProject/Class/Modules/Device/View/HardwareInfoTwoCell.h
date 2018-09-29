//
//  HardwareInfoOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidHardwareInfoTwoBlock)(NSString *count);


@interface HardwareInfoTwoCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidHardwareInfoTwoBlock didHardwareInfoTwoBlock;

@end
