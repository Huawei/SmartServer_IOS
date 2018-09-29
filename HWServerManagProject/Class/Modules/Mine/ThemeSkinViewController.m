//
//  ThemeSkinViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/14.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "ThemeSkinViewController.h"

@interface ThemeSkinViewController ()

@end

@implementation ThemeSkinViewController {
    UIButton *btn1;
    UIButton *btn2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"ThemeSkin");
    
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"selectcolor");
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    [self.view addSubview:secView];

    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 70, 60, 60);
    btn1.layer.cornerRadius = 5;
    btn1.layer.masksToBounds = YES;
    btn1.backgroundColor = NormalApp_nav_Style_Color;
    [self.view addSubview:btn1];
//    [btn1 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
//    [btn1 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateHighlighted];
//    [btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
//    [btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected|UIControlStateHighlighted];
    btn1.tag = 0;
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 70, 60, 60);
    btn2.layer.cornerRadius = 5;
    btn2.layer.masksToBounds = YES;
    btn2.backgroundColor = SelectApp_tabbar_Style_Color;
    [self.view addSubview:btn2];
//    [btn2 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
//    [btn2 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateHighlighted];
//    [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
//    [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected|UIControlStateHighlighted];
    btn2.tag = 1;
    
    [btn1 addTarget:self action:@selector(checkColorAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(checkColorAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *navcolorcheck = [[NSUserDefaults standardUserDefaults] objectForKey:APP_NAV_COLOR_CHECK];
    if (navcolorcheck == nil) {
        [btn1 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    } else {
        if ([navcolorcheck isEqualToString:@"0"]) {
            
            [btn1 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        } else {
            [btn2 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
    }
}

- (void)checkColorAction:(UIButton *)btn {
    
    if (btn.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:APP_NAV_COLOR_CHECK];

        [HWGlobalData shared].navColor = NormalApp_nav_Style_Color;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UINavigationBar appearance].barTintColor = NormalApp_nav_Style_Color;
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
        
        self.navigationController.navigationBar.barTintColor = NormalApp_nav_Style_Color;
//        [HWGlobalData shared].navColor = NormalApp_nav_Style_Color;

    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:APP_NAV_COLOR_CHECK];

//        [HWGlobalData shared].navColor = NormalApp_tabbar_Style_Color;
//
        self.navigationController.navigationBar.barTintColor = SelectApp_tabbar_Style_Color;
        
        [HWGlobalData shared].navColor = SelectApp_tabbar_Style_Color;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UINavigationBar appearance].barTintColor = SelectApp_tabbar_Style_Color;
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];

    }
    if (btn == btn1) {
        [btn1 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    } else {
        [btn2 setImage:[UIImage imageNamed:@"one_whiteGouicon"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

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
