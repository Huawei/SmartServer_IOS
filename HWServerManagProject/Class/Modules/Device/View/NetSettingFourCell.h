//
//  NetSettingTwoCell.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidRefreshVlanBlock)(NSDictionary *data,NSString *odata_id);

@interface NetSettingFourCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *dataDic;
@property (copy, nonatomic) NSString *odata_id;
@property (copy, nonatomic) DidRefreshVlanBlock didRefreshVlanBlock;


@end
