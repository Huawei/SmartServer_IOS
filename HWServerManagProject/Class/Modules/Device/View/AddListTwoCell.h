//
//  AddListTwoCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangeStatusBlock)(BOOL onOff);
typedef void(^DidChangeStatusIndexBlock)(BOOL onOff,NSInteger row);

@interface AddListTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (assign, nonatomic) NSInteger row;

@property (copy, nonatomic) DidChangeStatusBlock didChangeStatusBlock;
@property (copy, nonatomic) DidChangeStatusIndexBlock didChangeStatusIndexBlock;
@end
