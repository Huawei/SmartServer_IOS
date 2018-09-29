//
//  AppDelegate.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "AppDelegate.h"
#import "DLSFTPConnection.h"
#import "DLSFTPFile.h"
#import "HWWindow.h"
#import "ViewController.h"
#import <UMMobClick/MobClick.h>
#import "RefreshLogManager.h"

@interface AppDelegate ()

@property (assign, nonatomic) BOOL isToBackground;

@end

@implementation AppDelegate

- (void)setTimerEnable:(BOOL)timerEnable {
    _timerEnable = timerEnable;
    HWWindow *window = (HWWindow *)self.window;
    [window setTimerEnable:timerEnable];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BLLog(@"删除之前的session ============ %@",[HWGlobalData shared].session_id);
    if ([HWGlobalData shared].session_id && [HWGlobalData shared].curDevice && [HWGlobalData shared].XAuthToken) {
//        [ABNetWorking deleteWithSessionService:session_id port:port deviceName:deviceName block:^{
//
//        }];
        [ABNetWorking deleteWithSessionService:^{
            
        }];
    }
  

    UMConfigInstance.appKey = @"5adc5292b27b0a47650001c4";
    UMConfigInstance.eSType = E_UM_NORMAL; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setLogEnabled:YES];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:HEXCOLOR(0x25c4a4)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString *navcolorcheck = [[NSUserDefaults standardUserDefaults] objectForKey:APP_NAV_COLOR_CHECK];
    if (navcolorcheck == nil) {
        [HWGlobalData shared].navColor = NormalApp_nav_Style_Color;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UINavigationBar appearance].barTintColor = NormalApp_nav_Style_Color;
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    } else {
        if ([navcolorcheck isEqualToString:@"0"]) {
            [HWGlobalData shared].navColor = NormalApp_nav_Style_Color;

            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [UINavigationBar appearance].barTintColor = NormalApp_nav_Style_Color;
            [[UINavigationBar appearance] setTranslucent:NO];
            [[UINavigationBar appearance] setShadowImage:[UIImage new]];
        } else {
            [HWGlobalData shared].navColor = SelectApp_tabbar_Style_Color;

            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [UINavigationBar appearance].barTintColor = SelectApp_tabbar_Style_Color;
            [[UINavigationBar appearance] setTranslucent:NO];
            [[UINavigationBar appearance] setShadowImage:[UIImage new]];
        }
        
    }
    
    //删除本地日志
    [RefreshLogManager deletefileGiveUpLog];
    
    
    
    [UITabBar appearance].barTintColor = HEXCOLOR(0xfafafa);
    
    NSString *locallanguage = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
    if (locallanguage == nil) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage hasPrefix:@"zh-Hans"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
        }
    }
    
    HWWindow *window = [[HWWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window = window;
    
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [ViewController new];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.isToBackground = YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if (self.isToBackground) {
        self.isToBackground = NO;
        NSString *localPwdLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
        if (localPwdLock != nil && localPwdLock.length == 6) {
            HWWindow *window = (HWWindow *)self.window;
            if (!window.isShowPwd) {
               [window showPwdInputAction];
            }
            
        }
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
//    if ([HWGlobalData shared].session_id && [HWGlobalData shared].curDevice.deviceName && [HWGlobalData shared].curDevice.port && [HWGlobalData shared].XAuthToken) {
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:[HWGlobalData shared].session_id forKey:@"localsession_id"];
//        [userDefaults synchronize];
//        [userDefaults setObject:[HWGlobalData shared].curDevice.deviceName forKey:@"localdeviceName"];
//        [userDefaults synchronize];
//        [userDefaults setObject:[HWGlobalData shared].curDevice.port forKey:@"localport"];
//        [userDefaults synchronize];
//        [userDefaults setObject:[HWGlobalData shared].XAuthToken forKey:@"localXAuthToken"];
//        [userDefaults synchronize];
//        BLLog(@"存储本地了");
//    }

    

    //    if ([HWGlobalData shared].XAuthToken.length > 0) {
//
//
//
//
//        NSString *urlstring = [NSString stringWithFormat:@"%@:%@/redfish/v1/SessionService/Sessions/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,[HWGlobalData shared].session_id];
//        if (![urlstring hasPrefix:@"http"]) {
//            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
//        }
//        [TYNetWorking deleteWithUrlString:urlstring parameters:nil success:^(NSDictionary *result) {
//
//        } failure:^(NSError *error) {
//
//        }];
//
//
//    }
    
}


@end
