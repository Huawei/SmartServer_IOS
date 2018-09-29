//
//  FoundAddCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSafeOnBlock)(BOOL onOff, NSInteger row);

@interface MineOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;

@property (assign, nonatomic) NSInteger row;

@property (copy, nonatomic) DidSafeOnBlock didSafeOnBlock;
@end
