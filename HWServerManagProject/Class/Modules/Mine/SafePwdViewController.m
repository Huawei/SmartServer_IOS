//
//  MineViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "SafePwdViewController.h"
#import "MineOneCell.h"
#import "MineTwoCell.h"
#import "AddDeviceViewController.h"
#import "DeviceDetailViewController.h"
#import "SafePwdInputViewController.h"
#import "HWNavigationController.h"
#import "NSString+QDTouchID.h"
#import "SafePwdChangeViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface SafePwdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) BOOL isPwdSafe;
@property (assign, nonatomic) BOOL isFingerprintSafe;


@end

@implementation SafePwdViewController {
    NSString *localPwdLock;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - TabHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"MineOneCell" bundle:nil] forCellReuseIdentifier:@"MineOneCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MineTwoCell" bundle:nil] forCellReuseIdentifier:@"MineTwoCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    localPwdLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
    if (localPwdLock != nil && localPwdLock.length == 6) {
        self.isPwdSafe = YES;
    }else {
        self.isPwdSafe = NO;
    }
    
    NSString *localTouchLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_Touch_DATA];
    if (localTouchLock && [localTouchLock isEqualToString:@"1"]) {
        self.isFingerprintSafe = YES;
    } else {
        self.isFingerprintSafe = NO;
    }

    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"securitysettings2");
    self.view.backgroundColor = NormalApp_Line_Color;
   
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isPwdSafe) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    secView.backgroundColor = [UIColor clearColor];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    secView.backgroundColor = [UIColor clearColor];
    return secView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2) {
        MineOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineOneCell"];
        cell.row = indexPath.row;
        
        switch (indexPath.row) {
            case 0:
                cell.onOffSwitch.on = self.isPwdSafe;
                cell.leftLabel.text = LocalString(@"passwordprotection");
                cell.iconIMV.image = [UIImage imageNamed:@"one_cellsafe0icon"];
                break;
            case 1:
                cell.onOffSwitch.on = self.isFingerprintSafe;
                cell.leftLabel.text = LocalString(@"fingerprintunlock");
                cell.iconIMV.image = [UIImage imageNamed:@"one_cellsafe1icon"];
                break;
                
            default:
                break;
        }
        
        __weak typeof(self) weakSelf = self;
        cell.didSafeOnBlock = ^(BOOL onOff, NSInteger row) {
            if (row == 0) {
                if (!onOff) {
                    SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
                    vc.isOnPassword = NO;
                    vc.isShowFingerprint = YES;
                    [weakSelf.navigationController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
                } else {
                    SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
                    vc.isOnPassword = YES;
                    [weakSelf.navigationController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
                }
            } else if (row == 1) {
                
                if ([NSString judueIPhonePlatformSupportTouchID])  {
                    if (localPwdLock && localPwdLock.length == 6) {
                        if (onOff) {
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:PWD_Touch_DATA];
                            weakSelf.isFingerprintSafe = YES;
                        } else {
                            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:PWD_Touch_DATA];
                            weakSelf.isFingerprintSafe = NO;

                        }
                    } else {
                        [weakSelf.view makeToast:LocalString(@"pleasesetpwdlockfirst")];
                    }
                    
                } else {
                    [weakSelf.view makeToast:LocalString(@"devicenosupportfingerprint")];

                }
                
                
                

            }
        };
        
        
        return cell;
    } else {
      
        MineTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTwoCell"];
        cell.leftLabel.text = LocalString(@"PasswordProtection");
        cell.iconIMV.image = [UIImage imageNamed:@"one_cellsafe2icon"];
        
        
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (localPwdLock) {
            SafePwdChangeViewController *vc = [[SafePwdChangeViewController alloc] initWithNibName:@"SafePwdChangeViewController" bundle:nil];
            [self.navigationController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        } else {
            [self.view makeToast:@"请先设置密码锁"];
        }
        
    }
//    DeviceDetailViewController *vc = [[DeviceDetailViewController alloc] initWithNibName:@"DeviceDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
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
 
 ^{
 NSString *tempstr =[[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
 if (tempstr != nil && tempstr.length == 6) {
 }else {
 [self.view makeToast:LocalString(@"pwdhaveclose")];
 }
 }
 */

@end
