//
//  WPNavigationController.m
//  WallPaperIPhone
//
//  Created by 陈主祥 on 2017/8/29.
//  Copyright © 2017年 czx. All rights reserved.
//

#import "HWNavigationController.h"
#import "HWBaseViewController.h"

@interface HWNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        weakSelf.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    //判断第二级界面是否显示下边标签栏
    if (self.childViewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];
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
