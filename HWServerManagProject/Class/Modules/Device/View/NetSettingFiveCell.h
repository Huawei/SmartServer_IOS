//
//  NetSettingTwoCell.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidPopAreaTimeBlock)(NSInteger row,NSDictionary *dataDic);
typedef void(^DidRefreshAreaTimeBlock)(NSDictionary *dataDic,NSString *dateTimeLocalOffset);

@interface NetSettingFiveCell : UICollectionViewCell

@property (copy, nonatomic) NSString *dateTimeLocalOffset;//时区
@property (copy, nonatomic) DidPopAreaTimeBlock didPopAreaTimeBlock;
@property (copy, nonatomic) DidRefreshAreaTimeBlock didRefreshAreaTimeBlock;

@end
