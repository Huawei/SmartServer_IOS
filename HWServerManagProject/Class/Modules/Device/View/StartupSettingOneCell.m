//
//  StartupSettingOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "StartupSettingOneCell.h"
#import "StartupSettingOneSubCell.h"
#import "AddListTwoCell.h"

@interface StartupSettingOneCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIButton *submitBtn;
@property (assign, nonatomic) BOOL onOff;

@end


@implementation StartupSettingOneCell {
    NSInteger didSelectIndex;
    UILabel *alertLabel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 40) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"StartupSettingOneSubCell" bundle:nil] forCellReuseIdentifier:@"StartupSettingOneSubCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    didSelectIndex = -1;
//    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    footerView.backgroundColor = [UIColor clearColor];
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"submit") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submitBtn];
    self.tableView.tableFooterView = footerView;
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, ScreenWidth-24, 40)];
    [footerView addSubview:alertLabel];
    alertLabel.text = LocalString(@"didongmoshialert4");
    alertLabel.font = [UIFont systemFontOfSize:13];
    alertLabel.textColor = RGBCOLOR(39, 177, 149);;
    alertLabel.numberOfLines = 0;
    alertLabel.hidden = YES;
    [alertLabel sizeToFit];
    self.submitBtn.frame = CGRectMake(12, alertLabel.bottom + 10, ScreenWidth - 24, 40);

    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(@25);
    }];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
}

- (void)setIsSupportStartMode:(BOOL)isSupportStartMode {
    _isSupportStartMode = isSupportStartMode;
    alertLabel.hidden = YES;
    if (isSupportStartMode) {
        self.submitBtn.hidden = NO;
        
    } else {
        self.submitBtn.hidden = YES;
        if (!self.isFirst) {
            alertLabel.hidden = NO;
        }
        
    }
    
    
}

- (void)setBootSourceOverrideMode:(NSString *)bootSourceOverrideMode {
    _bootSourceOverrideMode = bootSourceOverrideMode;
    if (!self.isFirst) {
        
        if ([bootSourceOverrideMode isEqualToString:@"Legacy"]) {
            didSelectIndex = 0;
        } else if ([bootSourceOverrideMode isEqualToString:@"UEFI"]) {
            didSelectIndex = 1;
        } else {
            didSelectIndex = -1;
        }
//        alertLabel.hidden = NO;
    } else {
//        alertLabel.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (void)setBootSourceOverrideTarget:(NSString *)bootSourceOverrideTarget {
    _bootSourceOverrideTarget = bootSourceOverrideTarget;
    
    if (self.isFirst) {
        
        if ([bootSourceOverrideTarget isEqualToString:@"None"]) {
            didSelectIndex = 0;
        } else if ([bootSourceOverrideTarget isEqualToString:@"Pxe"]) {
            didSelectIndex = 1;
        } else if ([bootSourceOverrideTarget isEqualToString:@"Floppy"]) {
            didSelectIndex = 2;
        } else if ([bootSourceOverrideTarget isEqualToString:@"Cd"]) {
            didSelectIndex = 3;
        } else if ([bootSourceOverrideTarget isEqualToString:@"Hdd"]) {
            didSelectIndex = 4;
        } else if ([bootSourceOverrideTarget isEqualToString:@"BiosSetup"]) {
            didSelectIndex = 5;
        }
     
    }
    
    [self.tableView reloadData];
}

- (void)setBootSourceOverrideEnabled:(NSString *)bootSourceOverrideEnabled {
    _bootSourceOverrideEnabled = bootSourceOverrideEnabled;
    
    if ([bootSourceOverrideEnabled isEqualToString:@"Disabled"]){
        self.onOff = NO;
    } else if ([bootSourceOverrideEnabled isEqualToString:@"Continuous"]){
        self.onOff = YES;
    } else {
        self.onOff = NO;
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFirst) {
        return 7;
    }
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    if (self.isFirst) {
        label.text = LocalString(@"bootmediium");
    } else {
        label.text = LocalString(@"bootmode");
    }
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StartupSettingOneSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartupSettingOneSubCell"];
    if (self.isSupportStartMode) {
        cell.iconIMV.alpha = 1;
    } else {
        cell.iconIMV.alpha = 0.6;
    }
    if (didSelectIndex == indexPath.row) {
        cell.isChecked = YES;
    } else {
        cell.isChecked = NO;
    }
    
    if (self.isFirst) {
        switch (indexPath.row) {
            case 0: {
                cell.titleLabel.text = LocalString(@"bootnooverride");
            }
                
                break;
            case 1:
                cell.titleLabel.text = LocalString(@"bootpex");

                break;
            case 2:
                cell.titleLabel.text = LocalString(@"bootfddredevice");

                break;
            case 3:
                cell.titleLabel.text = LocalString(@"bootdvd");

                break;
            case 4:
                cell.titleLabel.text = LocalString(@"bootharddrive");

                break;
            case 5:
                cell.titleLabel.text = LocalString(@"bootnbioset");
                break;
            case 6: {
                AddListTwoCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
                cell2.leftLabel.text = LocalString(@"bootneffper");
                cell2.onOffSwitch.on = self.onOff;
                __weak typeof(self) weakSelf = self;
                cell2.didChangeStatusBlock = ^(BOOL onOff) {
                    weakSelf.onOff = onOff;
                };
                return cell2;
            }

                break;
            default:
                cell.titleLabel.text = @"";
                
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"Legacy";
                
                break;
            case 1:
                cell.titleLabel.text = @"UEFI";
                break;
           
            default:
                cell.titleLabel.text = @"";
                
                break;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSupportStartMode) {
        if (indexPath.row < 6) {
            didSelectIndex = indexPath.row;
            [tableView reloadData];
        }
    }
    
}

- (void)submitAction {
    
    NSDictionary *param = @{};
    NSString *tempstr = self.bootSourceOverrideTarget;
    NSString *tempstr2 = self.bootSourceOverrideEnabled;
    NSString *tempstr3 = self.bootSourceOverrideMode;
    
    if (self.isFirst) {
        if (didSelectIndex < 0 || didSelectIndex > 5) {
            return;
        }
        
        switch (didSelectIndex) {
            case 0:
                tempstr = @"None";
                break;
            case 1:
                tempstr = @"Pxe";
                break;
            case 2:
                tempstr = @"Floppy";
                break;
            case 3:
                tempstr = @"Cd";
                break;
            case 4:
                tempstr = @"Hdd";
                break;
            case 5:
                tempstr = @"BiosSetup";
                break;
            default:
                break;
        }
        if (self.onOff) {
            tempstr2 = @"Continuous";
        } else {
            tempstr2 = @"Disabled";
        }
        param = @{@"Boot":@{@"BootSourceOverrideEnabled":tempstr2,@"BootSourceOverrideTarget":tempstr,@"BootSourceOverrideMode":tempstr3}};
    } else {
        
//        __weak typeof(self) weakSelf = self;
//        __block NSString *tempstr3Block = tempstr3;
//        __block NSDictionary *paramBlock = param;
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"didongmoshialert1") preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            if (didSelectIndex < 0 || didSelectIndex > 1) {
                return;
            }
            
            
            switch (didSelectIndex) {
                case 0:
                    tempstr3 = @"Legacy";
                    break;
                case 1:
                    tempstr3 = @"UEFI";
                    break;
                default:
                    break;
            }
            
            param = @{@"Boot":@{@"BootSourceOverrideEnabled":tempstr2,@"BootSourceOverrideTarget":tempstr,@"BootSourceOverrideMode":tempstr3}};
            [self submitRequest:param value1:tempstr value2:tempstr2 value3:tempstr3];
            
//        }]];
//        [weakSelf.controller.navigationController presentViewController:alert animated:YES completion:nil];
        
        
        
        
        return;
    }
    
    [self submitRequest:param value1:tempstr value2:tempstr2 value3:tempstr3];
}

- (void)submitRequest:(NSDictionary *)param value1:(NSString *)tempstr value2:(NSString *)tempstr2 value3:(NSString *)tempstr3 {
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:param success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        BLLog(@"%@",result);
        
        if (weakSelf.isFirst) {
            NSDictionary *boot = result[@"Boot"];
            if (boot.isSureDictionary) {
                NSString *bootSourceOverrideEnabled = boot[@"BootSourceOverrideEnabled"];
                NSString *bootSourceOverrideTarget = boot[@"BootSourceOverrideTarget"];
                if (bootSourceOverrideTarget.isSureString && [bootSourceOverrideTarget isEqualToString:tempstr] && bootSourceOverrideEnabled.isSureString && [bootSourceOverrideEnabled isEqualToString:tempstr2]) {
                    [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
                } else {
                    [weakSelf.contentView makeToast:LocalString(@"operationfail")];
                }
            } else {
                [weakSelf.contentView makeToast:LocalString(@"operationfail")];
            }
        } else {
            NSDictionary *boot = result[@"Boot"];
            if (boot.isSureDictionary) {
                NSString *bootSourceOverrideMode = boot[@"BootSourceOverrideMode"];
                if (bootSourceOverrideMode.isSureString && [bootSourceOverrideMode isEqualToString:tempstr3]) {
                    [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
                } else {
                    [weakSelf.contentView makeToast:LocalString(@"operationfail")];
                }
            } else {
                [weakSelf.contentView makeToast:LocalString(@"operationfail")];
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        //        [weakSelf.contentView makeToast:@"操作失败"];
    }];
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSDictionary *boot = result[@"Boot"];
        if (boot.isSureDictionary) {
            weakSelf.bootSourceOverrideEnabled = boot[@"BootSourceOverrideEnabled"];
            weakSelf.bootSourceOverrideTarget = boot[@"BootSourceOverrideTarget"];
            weakSelf.bootSourceOverrideMode = boot[@"BootSourceOverrideMode"];
        }
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

@end
