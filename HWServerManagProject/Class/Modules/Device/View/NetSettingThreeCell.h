//
//  NetSettingTwoCell.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidRefreshNetBlock)(NSDictionary *data,NSString *odata_id);
typedef NSString *(^DidGetHostNameBlock)(void);

@interface NetSettingThreeCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *dataDic;
@property (weak, nonatomic) UIViewController *controller;
@property (copy, nonatomic) NSString *odata_id;
@property (copy, nonatomic) DidRefreshNetBlock didRefreshNetBlock;
@property (copy, nonatomic) DidGetHostNameBlock didGetHostNameBlock;

@end
