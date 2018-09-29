//
//  LocateLampViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/1.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "LocateLampViewController.h"
#import "AddListTwoCell.h"
#import <QuartzCore/QuartzCore.h>

@interface LocateLampViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *submitBtn;

@property (copy, nonatomic) NSString *indicatorLED;

@end

@implementation LocateLampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = HEXCOLOR(0xF1F1F1);
    self.title = LocalString(@"devicedetailuid");
    [self createBackBtn];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StartupSettingOneSubCell" bundle:nil] forCellReuseIdentifier:@"StartupSettingOneSubCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//    footerView.backgroundColor = [UIColor clearColor];
//    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
//    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
//    self.submitBtn.layer.cornerRadius = 4;
//    self.submitBtn.layer.masksToBounds = YES;
//    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [footerView addSubview:self.submitBtn];
    self.tableView.tableFooterView = footerView;
//    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getData];

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
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = nextbuttonitem;
    [nextbuttonitem setTintColor:HEXCOLOR(0xffffff)];
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction {
    
}

-(CABasicAnimation *)opacityForever_Animation:(float)time {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.indicatorLED) {
//        if ([self.indicatorLED isEqualToString:@"Lit"]) {
            return 2;
//        } else if ([self.indicatorLED isEqualToString:@"Blinking"]) {
//            return 2;
//        }
//        return 2;
//    }
//    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 45)];
    label.text = LocalString(@"devicedetailuid");
    label.textColor = HEXCOLOR(0x333333);
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 115, 0, 100, 35)];
    label2.text = LocalString(@"indicator_state_off");
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = NormalApp_TableView_Title_Style_Color;
    label2.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.top.bottom.equalTo(@0);
    }];
    
    UIImageView *iconIMV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [secView addSubview:iconIMV];
    iconIMV.contentMode = UIViewContentModeScaleAspectFit;
    [iconIMV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label2.mas_left).offset(-3);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    
    [iconIMV.layer removeAllAnimations];
    label2.text = @"";
    iconIMV.image = nil;
    if (self.indicatorLED) {
        if ([self.indicatorLED isEqualToString:@"Off"]) {
            label2.text = LocalString(@"indicator_state_off");
            iconIMV.image = [UIImage imageNamed:@"one_devicelamp2"];

        } else if ([self.indicatorLED isEqualToString:@"Lit"]) {
            label2.text = LocalString(@"indicator_state_lit");
            iconIMV.image = [UIImage imageNamed:@"one_devicelamp1"];

        } else if ([self.indicatorLED isEqualToString:@"Blinking"]) {
            label2.text = LocalString(@"indicator_state_blinking");
            iconIMV.image = [UIImage imageNamed:@"one_devicelamp1"];
            [iconIMV.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
            
        } else {
            label2.text =  LocalString(@"indicator_state_unknown");
            iconIMV.image = [UIImage imageNamed:@"one_devicelamp2"];

        }
    } else {
//        label2.text =  LocalString(@"indicator_state_unknown");
//        iconIMV.image = [UIImage imageNamed:@"one_devicelamp1"];
        label2.text = @"";
        iconIMV.image = nil;
    }
    
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddListTwoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
    if (indexPath.row == 0) {
        cell1.leftLabel.text = LocalString(@"devicedetailuid");
        if (self.indicatorLED) {
            if ([self.indicatorLED isEqualToString:@"Lit"]) {
                cell1.onOffSwitch.on = YES;
            } else  if ([self.indicatorLED isEqualToString:@"Blinking"]) {
                cell1.onOffSwitch.on = YES;
            } else {
                cell1.onOffSwitch.on = NO;
            }
        }
        
        __weak typeof(self) weakSelf = self;
        cell1.didChangeStatusIndexBlock = ^(BOOL onOff, NSInteger row) {
            if (onOff) {
                [weakSelf changeLED:@"Lit"];
            } else {
                [weakSelf changeLED:@"Off"];
            }
        };
        
    } else {
        cell1.leftLabel.text = LocalString(@"indicator_state_blinking");
        if (self.indicatorLED) {
            if ([self.indicatorLED isEqualToString:@"Blinking"]) {
                cell1.onOffSwitch.on = YES;

            } else {
                cell1.onOffSwitch.on = NO;
            }
        }
        __weak typeof(self) weakSelf = self;
        __weak typeof(cell1) weakCell = cell1;
        cell1.didChangeStatusIndexBlock = ^(BOOL onOff, NSInteger row) {
            if (weakSelf.indicatorLED) {
                if ([self.indicatorLED isEqualToString:@"Off"]) {
                    
                    weakCell.onOffSwitch.on = NO;
                    [weakSelf.view makeToast:@"请先打开定位灯"];
                } else if ([self.indicatorLED isEqualToString:@"Lit"] || [self.indicatorLED isEqualToString:@"Blinking"]) {
                    
                    if (onOff) {
                        [weakSelf changeLED:@"Blinking"];
                    } else {
                        [weakSelf changeLED:@"Lit"];
                    }
                    
                }
            } else {
                weakCell.onOffSwitch.on = NO;
                [weakSelf.view makeToast:@"请先打开定位灯"];
            }
        };
    }
    return cell1;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeLED:(NSString *)state {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"IndicatorLED":state} success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BLLog(@"%@",result);
        NSString *IndicatorLED = result[@"IndicatorLED"];
        if (IndicatorLED.isSureString) {
            weakSelf.indicatorLED = IndicatorLED;
        }
        [weakSelf.tableView reloadData];
        [weakSelf getData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf getData];
    }];
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        NSString *IndicatorLED = result[@"IndicatorLED"];
        if (IndicatorLED.isSureString) {
            weakSelf.indicatorLED = IndicatorLED;
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
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
