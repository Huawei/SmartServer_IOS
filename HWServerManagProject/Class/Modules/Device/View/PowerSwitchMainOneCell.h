//
//  PowerSwitchMainOneCell.h
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/17.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidControlCompleteBlock)(NSString *powerStateStr);

@interface PowerSwitchMainOneCell : UICollectionViewCell

@property (copy, nonatomic) NSString *powerStateStr;
@property (copy, nonatomic) NSString *powerStateImageName;

@property (copy, nonatomic) DidControlCompleteBlock didControlCompleteBlock;

@end
