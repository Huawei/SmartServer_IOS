//
//  AddListOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSureInputBlock)(NSString *value);

@interface AddListOneCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (assign, nonatomic) BOOL isNumTask;

@property (copy, nonatomic) DidSureInputBlock didSureInputBlock;

@end
