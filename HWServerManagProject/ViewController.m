//
//  ViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "ViewController.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "SafePwdInputViewController.h"
#import "HWNavigationController.h"
#import "TouchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BLLog(@"%@",CustomLocalizedString(@"timezoneHW", nil));
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.window.rootViewController = [MainTabBarController new];
    
    NSString *firstStr = [[NSUserDefaults standardUserDefaults] objectForKey:App_First_In];
    if (firstStr == nil) {
        
        SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
        vc.isFirst = YES;
        [appdelegate.window.rootViewController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:NO completion:nil];
    } else {
        
        NSString *localPwdLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
        if (localPwdLock != nil && localPwdLock.length == 6) {
     
            
            SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
            vc.isToInApp = YES;
            vc.isShowFingerprint = YES;
            [appdelegate.window.rootViewController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:NO completion:nil];
            
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
