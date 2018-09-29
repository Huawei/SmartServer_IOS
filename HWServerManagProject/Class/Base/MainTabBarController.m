//
//  MainTabBarController.m
//  BlueLightAPP
//
//  Created by 陈主祥 on 2017/3/6.
//  Copyright © 2017年 郭艺伟. All rights reserved.
//

#import "MainTabBarController.h"
#import "FoundViewController.h"
#import "DeviceListViewController.h"
#import "HWNavigationController.h"
#import "MineViewController.h"


@interface MainTabBarController ()<UITabBarControllerDelegate>


@end

@implementation MainTabBarController {
    NSInteger countDown;
    UINavigationController *fourNav;
    
//    UIView *whiteView;
    HWNavigationController *vc2Nav;
}

    
    

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    countDown = 5;

    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    DeviceListViewController *vc1 = [[DeviceListViewController alloc]init];
    HWNavigationController *vc1Nav = [[HWNavigationController alloc]initWithRootViewController:vc1];
    vc1Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalString(@"devicemanagement") image:[[UIImage imageNamed:@"one_tabbaricon0_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"one_tabbaricon0_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [vc1Nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];



    FoundViewController *vc2 = [[FoundViewController alloc]init];
    vc2Nav = [[HWNavigationController alloc]initWithRootViewController:vc2];
    vc2Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalString(@"found") image:[[UIImage imageNamed:@"one_tabbaricon1_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"one_tabbaricon1_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [vc2Nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];

    MineViewController *vc4 = [[MineViewController alloc]init];
    HWNavigationController *vc4Nav = [[HWNavigationController alloc]initWithRootViewController:vc4];
    vc4Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalString(@"mine") image:[[UIImage imageNamed:@"one_tabbaricon2_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"one_tabbaricon2_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [vc4Nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    fourNav = vc4Nav;


    self.viewControllers = @[vc1Nav,vc2Nav,vc4Nav];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       SelectApp_tabbar_Style_Color, NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
//    [[UITabBar appearance] setTintColor:NormalApp_tabbar_Style_Color];


    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguagesNoti" object:nil];

}

- (void)changeLanguageAction {
    vc2Nav.tabBarItem.title = LocalString(@"found");
}

- (void)toShowWhiteView {
//    if ([HWGlobalData shared].whiteBGShow) {
//        [self.view bringSubviewToFront:whiteView];
//        whiteView.hidden = NO;
//    } else {
//        whiteView.hidden = YES;
//    }
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (viewController == fourNav) {
//        LoginViewController *vc = [[LoginViewController alloc]init];
//        WPNavigationController *vcNav = [[WPNavigationController alloc]initWithRootViewController:vc];
//        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vcNav animated:YES completion:nil];
//        return NO;
//    }
    return YES;
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
