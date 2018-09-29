//
//  SafePwdInputViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/2.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "SafePwdInputViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <LocalAuthentication/LAError.h>
#import "NSString+QDTouchID.h"
#import "SafePwdInputViewController.h"
#import "AppDelegate.h"
#import "HWNavigationController.h"

@interface SafePwdInputViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (weak, nonatomic) IBOutlet UILabel *topView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *fiBtn;

@property (weak, nonatomic) IBOutlet UILabel *pwd1Label;
@property (weak, nonatomic) IBOutlet UILabel *pwd2Label;
@property (weak, nonatomic) IBOutlet UILabel *pwd3Label;
@property (weak, nonatomic) IBOutlet UILabel *pwd4Label;
@property (weak, nonatomic) IBOutlet UILabel *pwd5Label;
@property (weak, nonatomic) IBOutlet UILabel *pwd6Label;

@property (weak, nonatomic) IBOutlet UIButton *alertBtn;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *data1Array;


@end

@implementation SafePwdInputViewController {
    BOOL isSecond;
    NSString *localPwdLock;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)data1Array {
    if (!_data1Array) {
        _data1Array = [NSMutableArray new];
    }
    return _data1Array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.clearBtn setTitle:LocalString(@"pwdclear") forState:UIControlStateNormal];
    [self.deleteBtn setTitle:LocalString(@"pwdremove") forState:UIControlStateNormal];
    
    self.alertLabel.text = LocalString(@"Pleaseenterpassword");
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.timerEnable = NO;
    
    if (self.isFirst) {
        self.title = LocalString(@"setapplock");
        self.alertLabel.text = LocalString(@"createapplock");
    } else if (self.isToInApp) {
        self.title = LocalString(@"unlock_title");

    } else {
        if (self.isOnPassword) {
            self.title = LocalString(@"openapplock");
        } else {
            self.title = LocalString(@"closeapplock");
        }
        
        [self createBackBtn];

    }
    
    self.topView.layer.borderColor = HEXCOLOR(0x25c4a4).CGColor;
    self.topView.layer.borderWidth = 0.5;
    self.bottomView.layer.borderColor = HEXCOLOR(0x25c4a4).CGColor;
    self.bottomView.layer.borderWidth = 0.5;
    localPwdLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
    
    
    self.fiBtn.hidden = YES;
    if (self.isShowFingerprint) {
        
        NSString *localTouchLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_Touch_DATA];
        if (localTouchLock && [localTouchLock isEqualToString:@"1"]) {
            self.fiBtn.hidden = NO;
            [self baseDemo];
        }
    }
}


- (void)createBackBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        btn.frame = CGRectMake(0,0, 60, 44);
    } else {
        btn.frame = CGRectMake(0,0, 70, 44);
    }
    [btn setImage:[UIImage imageNamed:@"one_navBackicon"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:LocalString(@"back") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = nextbuttonitem;
    [nextbuttonitem setTintColor:HEXCOLOR(0xffffff)];
    
}

- (void)backAction {
    AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelgate.timerEnable = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didBtnAction:(UIButton *)sender {
    self.alertBtn.hidden = YES;
    self.pwd1Label.text = @"";
    self.pwd2Label.text = @"";
    self.pwd3Label.text = @"";
    self.pwd4Label.text = @"";
    self.pwd5Label.text = @"";
    self.pwd6Label.text = @"";
    if (isSecond) {
        self.alertLabel.text = LocalString(@"pleaseenterpwdagain");
        if (sender.tag == 10) {
            [self.data1Array removeAllObjects];
        } else if (sender.tag == 11) {
            if (self.data1Array.count > 0) {
                [self.data1Array removeLastObject];
            }
        } else {
            if (self.data1Array.count < 6) {
                [self.data1Array addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
            }
        }
        
        for (NSInteger i = 0; i < self.data1Array.count; i++) {
            switch (i) {
                case 0:
                    self.pwd1Label.text = @"●";
                    break;
                case 1:
                    self.pwd2Label.text = @"●";
                    break;
                case 2:
                    self.pwd3Label.text = @"●";
                    break;
                case 3:
                    self.pwd4Label.text = @"●";
                    break;
                case 4:
                    self.pwd5Label.text = @"●";
                    break;
                case 5:
                    self.pwd6Label.text = @"●";
                    break;
                default:
                    break;
            }
        }
        

       
        if (self.dataArray.count == self.data1Array.count && self.data1Array.count == 6) {
            NSString *string1 = [self.dataArray componentsJoinedByString:@""];
            NSString *string2 = [self.data1Array componentsJoinedByString:@""];
            if ([string1 isEqualToString:string2]) {
                AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appdelgate.timerEnable = YES;
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"isfirstin" forKey:App_First_In];
                [[NSUserDefaults standardUserDefaults] setObject:string1 forKey:PWD_LOCK_DATA];
                appdelgate.timerEnable = YES;
            } else {
                self.alertBtn.hidden = NO;
                [self.dataArray removeAllObjects];
                [self.data1Array removeAllObjects];
                isSecond = NO;
                self.pwd1Label.text = @"";
                self.pwd2Label.text = @"";
                self.pwd3Label.text = @"";
                self.pwd4Label.text = @"";
                self.pwd5Label.text = @"";
                self.pwd6Label.text = @"";
                self.alertLabel.text = LocalString(@"pleaseenternewpwd");
                
            }
        }
        
        
  
        
    } else {
        self.alertLabel.text = LocalString(@"Pleaseenterpassword");
        if (sender.tag == 10) {
            [self.dataArray removeAllObjects];
            
        } else if (sender.tag == 11) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeLastObject];
            }
            
        } else {
            if (self.dataArray.count < 6) {
                [self.dataArray addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
            }
        }
        
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            switch (i) {
                case 0:
                    self.pwd1Label.text = @"●";
                    break;
                case 1:
                    self.pwd2Label.text = @"●";
                    break;
                case 2:
                    self.pwd3Label.text = @"●";
                    break;
                case 3:
                    self.pwd4Label.text = @"●";
                    break;
                case 4:
                    self.pwd5Label.text = @"●";
                    break;
                case 5:
                    self.pwd6Label.text = @"●";
                    break;
                default:
                    break;
            }
        }
        
        if (self.isFirst) {
            if (self.dataArray.count == 6) {
                isSecond = YES;
                self.alertLabel.text = LocalString(@"pleaseenterpwdagain");
                self.pwd1Label.text = @"";
                self.pwd2Label.text = @"";
                self.pwd3Label.text = @"";
                self.pwd4Label.text = @"";
                self.pwd5Label.text = @"";
                self.pwd6Label.text = @"";
            } else {
                self.alertLabel.text = LocalString(@"createapplock");
            }
        } else if (self.isToInApp) {
//            self.title = LocalString(@"unlock_title");
            if (self.dataArray.count == 6) {
                NSString *string1 = [self.dataArray componentsJoinedByString:@""];
                if ([string1 isEqualToString:localPwdLock]) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appdelgate.timerEnable = YES;
                } else {
                    [self.dataArray removeAllObjects];
                    [self.alertBtn setTitle:LocalString(@"inputpwderrorreenter") forState:UIControlStateNormal];
                    self.alertBtn.hidden = NO;
                    self.pwd1Label.text = @"";
                    self.pwd2Label.text = @"";
                    self.pwd3Label.text = @"";
                    self.pwd4Label.text = @"";
                    self.pwd5Label.text = @"";
                    self.pwd6Label.text = @"";
                }
            }
        } else if (self.isOnPassword) {
            if (self.dataArray.count == 6) {
                isSecond = YES;
                self.alertLabel.text = LocalString(@"pleaseenterpwdagain");
                self.pwd1Label.text = @"";
                self.pwd2Label.text = @"";
                self.pwd3Label.text = @"";
                self.pwd4Label.text = @"";
                self.pwd5Label.text = @"";
                self.pwd6Label.text = @"";
            }
        } else if (self.isOnPassword == NO) {
            if (self.dataArray.count == 6) {
                NSString *string1 = [self.dataArray componentsJoinedByString:@""];
                if ([string1 isEqualToString:localPwdLock]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:PWD_Touch_DATA];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PWD_LOCK_DATA];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"pwdhaveclose")];
                    }];
                    AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appdelgate.timerEnable = YES;
                } else {
                    [self.dataArray removeAllObjects];
                    [self.alertBtn setTitle:LocalString(@"inputpwderrorreenter") forState:UIControlStateNormal];
                    self.alertBtn.hidden = NO;
                    self.pwd1Label.text = @"";
                    self.pwd2Label.text = @"";
                    self.pwd3Label.text = @"";
                    self.pwd4Label.text = @"";
                    self.pwd5Label.text = @"";
                    self.pwd6Label.text = @"";
                }
            }
        }
    }
    
}

- (IBAction)showLAAction:(id)sender {
    
    [self baseDemo];
}

- (void)baseDemo{
    
    __weak typeof(self) weakSelf = self;
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = LocalString(@"fingerprintinputpwd");//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:LocalString(@"fingerprintalert") reply:^(BOOL success, NSError * _Nullable error) {
        
        
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                BLLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作
                    
                    if (!weakSelf.isOnPassword && !weakSelf.isFirst && !weakSelf.isToInApp) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:PWD_Touch_DATA];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:PWD_LOCK_DATA];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"pwdhaveclose")];
                        }];
                            AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            appdelgate.timerEnable = YES;
                        } else {
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                            AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            appdelgate.timerEnable = YES;
                        }

                        
                    
                   
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    LAError errorCode = error.code;
                    switch (errorCode) {
                            
                        case LAErrorAuthenticationFailed:
                        {
                            BLLog(@"授权失败"); // -1 连续三次指纹识别错误
                        }
                            break;
                        case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                        {
                            BLLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                        }
                            break;
                        case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                        {
                            BLLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
    
                            
                        }
                            break;
                        case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
                        {
                            BLLog(@"取消授权，如其他应用切入"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        }
                            break;
                        case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.
                            
                        {
                            BLLog(@"设备系统未设置密码"); // -5
                            [self.view makeToast:LocalString(@"fingerprintnoset")];
                        }
                            break;
                        case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                        {
                            BLLog(@"设备未设置Touch ID"); // -6
//                            [self.view makeToast:@"设备未设置Touch ID"];
                            [self.view makeToast:LocalString(@"fingerprintnoset")];

                        }
                            break;
                        case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                        {
                            BLLog(@"用户未录入指纹"); // -7
//                            [self.view makeToast:@"用户未录入指纹"];
                            [self.view makeToast:LocalString(@"fingerprintnoset")];

                        }
                            break;
                        case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        {
                            BLLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
//                            [self.view makeToast:@"Touch ID被锁，需要用户输入密码解锁"];
                            [self.view makeToast:LocalString(@"fingerprintnoset")];

                        }
                            break;
                        case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                        {
                            BLLog(@"用户不能控制情况下APP被挂起"); // -9
                        }
                            break;
                        case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                        {
                            BLLog(@"LAContext传递给这个调用之前已经失效"); // -10
                        }
                            break;
                    }
                    
                });
            }
        });
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
