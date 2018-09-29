//
//  SafePwdInputViewController.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/2.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWBaseViewController.h"

@interface SafePwdInputViewController : HWBaseViewController

@property (assign, nonatomic) BOOL isOnPassword;
@property (assign, nonatomic) BOOL isFirst;
@property (assign, nonatomic) BOOL isToInApp;

@property (assign, nonatomic) BOOL isShowFingerprint;


@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
