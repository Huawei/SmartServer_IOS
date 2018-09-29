//
//  AddListOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSureInput2Block)(NSString *value);

@interface AddListOne2Cell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;

@property (assign, nonatomic) BOOL isNumTask;

@property (copy, nonatomic) DidSureInput2Block didSureInputBlock;

@end
