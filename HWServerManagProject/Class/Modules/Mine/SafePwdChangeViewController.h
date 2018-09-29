//
//  SafePwdInputViewController.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/2.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWBaseViewController.h"

@interface SafePwdChangeViewController : HWBaseViewController

@property (assign, nonatomic) BOOL isChangePassword;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end
