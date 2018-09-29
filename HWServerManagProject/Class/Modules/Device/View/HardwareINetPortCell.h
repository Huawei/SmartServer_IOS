//
//  HardwareInfoOneSubCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HardwareINetPortCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;

@property (strong, nonatomic) NSDictionary *data;

@end
