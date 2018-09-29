//
//  TouchViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/3.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "TouchViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <LocalAuthentication/LAError.h>
#import "NSString+QDTouchID.h"
#import "SafePwdInputViewController.h"
#import "AppDelegate.h"
#import "HWNavigationController.h"

@interface TouchViewController ()

@end

@implementation TouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [HWGlobalData shared].whiteBGShow = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didShowWhiteView" object:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 0, 72, 72);
    [btn setImage:[UIImage imageNamed:@"ic_fingerprint_36dp.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(baseDemo) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    
    [self baseDemo];
    
}

- (void)baseDemo{
    
    __weak typeof(self) weakSelf = self;
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"输入密码";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                BLLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作
                    [HWGlobalData shared].whiteBGShow = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"didShowWhiteView" object:nil];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
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
                            
                            [weakSelf dismissViewControllerAnimated:NO completion:nil];
                            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
                            vc.isToInApp = YES;
                            [appdelegate.window.rootViewController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:NO completion:^{
                                [HWGlobalData shared].whiteBGShow = NO;
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"didShowWhiteView" object:nil];
                            }];
                           
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
                            [self.view makeToast:@"设备系统未设置指纹密码"];
                        }
                            break;
                        case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                        {
                            BLLog(@"设备未设置Touch ID"); // -6
                            [self.view makeToast:@"设备未设置Touch ID"];
                        }
                            break;
                        case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                        {
                            BLLog(@"用户未录入指纹"); // -7
                            [self.view makeToast:@"用户未录入指纹"];
                        }
                            break;
                        case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        {
                            BLLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                            [self.view makeToast:@"Touch ID被锁，需要用户输入密码解锁"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
