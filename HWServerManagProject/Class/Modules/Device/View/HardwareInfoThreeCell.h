//
//  HardwareInfoOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidHardwareInfoThreeBlock)(NSString *count);


@interface HardwareInfoThreeCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidHardwareInfoThreeBlock didHardwareInfoThreeBlock;

@end
