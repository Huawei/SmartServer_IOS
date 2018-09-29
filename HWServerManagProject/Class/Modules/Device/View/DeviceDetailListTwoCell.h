//
//  DeviceDetailListCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidToHealthCellBlock)(void);

@interface DeviceDetailListTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;
@property (copy, nonatomic) DidToHealthCellBlock didToHealthCellBlock;


@end
