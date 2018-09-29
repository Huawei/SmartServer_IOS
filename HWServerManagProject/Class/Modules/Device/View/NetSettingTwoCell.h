//
//  NetSettingTwoCell.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidRefreshNetPortBlock)(NSDictionary *data,NSString *odata_id);

@interface NetSettingTwoCell : UICollectionViewCell

@property (weak, nonatomic) UIViewController *controller;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (copy, nonatomic) NSString *odata_id;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSDictionary *managementNetworkPort;
@property (copy, nonatomic) NSString *networkPortMode;
@property (copy, nonatomic) DidRefreshNetPortBlock didRefreshNetPortBlock;


//固定模式：Fixed
//自适应模式：Automatic
@end
