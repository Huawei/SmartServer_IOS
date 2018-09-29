//
//  StartupSettingOneSubCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartupSettingOneSubCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;

@property (assign, nonatomic) BOOL isChecked;

@end
