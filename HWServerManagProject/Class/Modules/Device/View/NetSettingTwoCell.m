//
//  NetSettingTwoCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingTwoCell.h"
#import "NetSettingTwoSubCell.h"
#import "AddListCell.h"
#import "NetPortModelChangePopView.h"
#import "AppDelegate.h"

@interface NetSettingTwoCell()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) NetPortModelChangePopView *popView;

@property (strong, nonatomic) UILabel *noDataLabel;

@end

@implementation NetSettingTwoCell {
    NSInteger didSelectIndex;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (ScreenHeight - NavHeight - 40)/2 - 70, ScreenWidth, 50)];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.textColor = [UIColor grayColor];
        _noDataLabel.font = [UIFont systemFontOfSize:14];
        _noDataLabel.text = LocalString(@"thisnosuportfunc");
        [self.contentView addSubview:_noDataLabel];
    }
    return _noDataLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50 - 90) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = NO;
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    didSelectIndex = -1;
    self.popView = [[NSBundle mainBundle] loadNibNamed:@"NetPortModelChangePopView" owner:nil options:nil].lastObject;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NetSettingTwoSubCell" bundle:nil] forCellReuseIdentifier:@"NetSettingTwoSubCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavHeight - 50 - 90, ScreenWidth, 90)];
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
    self.tableView.tableFooterView = [UIView new];
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
    
    [self.contentView addSubview:footerView];
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    self.popView.didSelectNetPortModelBlock = ^(NSString *value) {
        if ([value isEqualToString:LocalString(@"ns_port_port_mode_fixed")]) {
            weakSelf.networkPortMode = @"Fixed";
        } else if ([value isEqualToString:LocalString(@"ns_port_port_mode_automatic")]) {
            weakSelf.networkPortMode = @"Automatic";
        }
        [weakSelf.tableView reloadData];
    };
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    NSDictionary *oem = dataDic[@"Oem"];
    if (oem.isSureDictionary) {
        NSDictionary *huawei = oem[@"Huawei"];
        if (huawei.isSureDictionary) {
            NSDictionary *ManagementNetworkPortdic = huawei[@"ManagementNetworkPort"];
            if (ManagementNetworkPortdic.isSureDictionary) {
                self.managementNetworkPort = ManagementNetworkPortdic;
            }
            self.networkPortMode = huawei[@"NetworkPortMode"];
            NSArray *temparray1 = huawei[@"ManagementNetworkPort@Redfish.AllowableValues"];
            if (temparray1.isSureArray) {
                self.dataArray = temparray1;
            } else {
                self.dataArray = nil;
            }
        }
    }
}

- (void)setNetworkPortMode:(NSString *)networkPortMode {
    _networkPortMode = networkPortMode;
    [self.tableView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    NSString *portNumber = self.managementNetworkPort[@"PortNumber"];
    NSString *type = self.managementNetworkPort[@"Type"];
    if (portNumber && type) {
        for (NSInteger i = 0; i < dataArray.count; i++) {
            NSDictionary *dic = dataArray[i];
            NSString *portNumber1 = dic[@"PortNumber"];
            NSString *type1 = dic[@"Type"];
            if (portNumber1 && type1) {
                if (portNumber1.integerValue == portNumber.integerValue && [type isEqualToString:type1]) {
                    didSelectIndex = i;
                    break;
                }
            }
        }
    }
    [self.tableView reloadData];
    if (_dataArray == nil || _dataArray.count == 0) {
        self.noDataLabel.hidden = NO;
        [self.contentView bringSubviewToFront:self.noDataLabel];
        self.submitBtn.hidden = YES;
    } else {
        self.noDataLabel.hidden = YES;
        self.submitBtn.hidden = NO;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        if (section == 0) {
            return 1;
        }
        return self.dataArray.count;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    if (self.dataArray.count > 0) {
        if (section == 0) {
            return 15;
        }
        return 50;
    }
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = NormalApp_BackgroundColor;
    secView.clipsToBounds = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5, ScreenWidth-30, 45)];
    if (section == 0) {
        label.text = @"";
    } else {
        label.text = LocalString(@"ns_port_section_port_selection");
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
    secView.backgroundColor = NormalApp_BackgroundColor;
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
        cell.leftLabel.text = LocalString(@"ns_port_label_port_type");
        cell.contentLabel.text = @"";
        if (self.networkPortMode && self.networkPortMode.isSureString) {
            if ([self.networkPortMode isEqualToString:@"Fixed"]) {
                cell.contentLabel.text = LocalString(@"ns_port_port_mode_fixed");
            } else if ([self.networkPortMode isEqualToString:@"Automatic"]) {
                cell.contentLabel.text = LocalString(@"ns_port_port_mode_automatic");
            }
        }
        return cell;
    } else {
        NetSettingTwoSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NetSettingTwoSubCell"];
        cell.iconIMV.alpha = 1;
        if (self.networkPortMode && self.networkPortMode.isSureString) {
            if ([self.networkPortMode isEqualToString:@"Fixed"]) {
                cell.iconIMV.alpha = 1;
            } else if ([self.networkPortMode isEqualToString:@"Automatic"]) {
                cell.iconIMV.alpha = 0.3;
            }
        }
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSString *type = dic[@"Type"];
        if (type.isSureString && [type isEqualToString:@"Dedicated"]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"eth2(%@)",LocalString(@"ns_port_port_type_dedicated")];
        } else if (type.isSureString && [type isEqualToString:@"Aggregation"]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"eth2(%@)",LocalString(@"ns_port_port_type_aggregation")];
        } else if (type.isSureString && [type isEqualToString:@"LOM"]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"Port%@(%@)",dic[@"PortNumber"],LocalString(@"ns_port_port_type_LOM")];
        } else if (type.isSureString && [type isEqualToString:@"ExternalPCIe"]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"PCIe%@(%@)",dic[@"PortNumber"],LocalString(@"ns_port_port_type_External_PCIe")];
        } else if (type.isSureString && [type isEqualToString:@"LOM2"]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"Port%@(%@)",dic[@"PortNumber"],LocalString(@"ns_port_port_type_LOM2")];
        } else {
           cell.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"PortNumber"]];
        }
        if (indexPath.row == didSelectIndex) {
            cell.isChecked = YES;
        } else {
            cell.isChecked = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        if (self.networkPortMode) {
            if ([self.networkPortMode isEqualToString:@"Fixed"]) {
                didSelectIndex = indexPath.row;
                [tableView reloadData];
            } else if ([self.networkPortMode isEqualToString:@"Automatic"]) {
            }
        }
        
        
    } else if (indexPath.section == 0) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate.window addSubview:self.popView];
        [self.popView reloadData];
    }
}

- (void)submitAction {
    if (!self.dataDic) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"ns_port_prompt_update_port") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.networkPortMode isEqualToString:@"Fixed"]) {
            if (didSelectIndex < self.dataArray.count || didSelectIndex > (self.dataArray.count-1)) {
                return;
            }
            NSDictionary *dic = self.dataArray[didSelectIndex];
            NSString *type = dic[@"Type"];
            NSString *portNumber = dic[@"PortNumber"];
            [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
            [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"Oem":@{@"Huawei":@{@"NetworkPortMode":@"Fixed",@"ManagementNetworkPort":@{@"Type":type,@"PortNumber":portNumber}}}} success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
                [weakSelf.controller.view makeToast:LocalString(@"operationsuccess")];
                
                [weakSelf getData];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
//                [weakSelf.controller.view makeToast:@"操作失败"];
            }];
        } else if ([self.networkPortMode isEqualToString:@"Automatic"]) {
            
            [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
            [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"Oem":@{@"Huawei":@{@"NetworkPortMode":@"Automatic"}}} success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
                [weakSelf.controller.view makeToast:LocalString(@"operationsuccess")];
                
                [weakSelf getData];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
//                [weakSelf.controller.view makeToast:@"操作失败"];
            }];
            
        }
    }]];
    [self.controller.navigationController presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    weakSelf.odata_id = odata_id;
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        
                        weakSelf.dataDic = result14;
                        if (weakSelf.didRefreshNetPortBlock) {
                            weakSelf.didRefreshNetPortBlock(result14, odata_id);
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                    break;
                }
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

@end
