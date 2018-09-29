//
//  NetSettingTwoCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingFourCell.h"
#import "AddListOneCell.h"
#import "AddListCell.h"
#import "AddListTwoCell.h"


@interface NetSettingFourCell()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;
@property (assign, nonatomic) BOOL VLANEnable;
@property (copy, nonatomic) NSString *VLANId;

@end

@implementation NetSettingFourCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListOneCell" bundle:nil] forCellReuseIdentifier:@"AddListOneCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
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
    
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    NSDictionary *VLAN = self.dataDic[@"VLAN"];
    if (VLAN.isSureDictionary) {
        NSNumber *VLANEnable0 = VLAN[@"VLANEnable"];
        self.VLANEnable = VLANEnable0.boolValue;
        self.VLANId = [NSString stringWithFormat:@"%@",VLAN[@"VLANId"]];
        
        [self.tableView reloadData];
    }
   
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.VLANEnable) {
        return 1;
    }
     return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = NormalApp_BackgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5, ScreenWidth-30, 45)];
    label.text = LocalString(@"ns_vlan_label_setting");
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
    if (indexPath.row == 0) {
        AddListTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
        cell.leftLabel.text = LocalString(@"ns_vlan_label_vlan");
        cell.onOffSwitch.on = self.VLANEnable;
        __weak typeof(self) weakSelf = self;
        cell.didChangeStatusIndexBlock = ^(BOOL onOff, NSInteger row) {
            weakSelf.VLANEnable = onOff;
            [weakSelf.tableView reloadData];
        };
        return cell;
    } else {
        AddListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListOneCell"];
        cell.isNumTask = YES;
        cell.leftLabel.text = LocalString(@"ns_vlan_label_vlan_id");
        cell.inputTF.placeholder = @"1~4094";
        cell.inputTF.text = self.VLANId;
        __weak typeof(self) weakSelf = self;
//        __weak typeof(cell) weakCell = cell;
        cell.didSureInputBlock = ^(NSString *value) {
            weakSelf.VLANId = value;
//            if (value.length > 0 && value.integerValue>4094) {
//                weakCell.inputTF.text = @"4094";
//            }
        };
        return cell;
    }
}

- (void)submitAction {
    [self.contentView endEditing:YES];
    
    if (self.VLANEnable) {
        if (self.VLANId.length == 0 || self.VLANId.integerValue == 0) {
            [self.contentView makeToast:LocalString(@"ns_vlan_hint_vlan_id")];
            return;
        } else if (self.VLANId.length > 0 && self.VLANId.integerValue > 4094) {
            [self.contentView makeToast:LocalString(@"ns_vlan_illegal_vlan_id")];
            return;
        }
    }
    
    NSDictionary *vlan = @{};
    if (!self.VLANEnable) {
        vlan = @{@"VLANEnable":@(self.VLANEnable)};
    } else {
        vlan = @{@"VLANEnable":@(self.VLANEnable),@"VLANId":@(self.VLANId.integerValue)};
    }
    if (self.odata_id.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
        __weak typeof(self) weakSelf = self;
        [ABNetWorking patchWithUrlWithAction:[self.odata_id substringWithRange:NSMakeRange(1, self.odata_id.length-1)] parameters:@{@"VLAN":vlan} success:^(NSDictionary *result) {
            BLLog(@"%@",result);
            [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
            
            [weakSelf getData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
            NSArray *Members = result[@"Members"];
            if (Members && [Members isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in Members) {
                    NSString *odata_id = dic[@"@odata.id"];
                    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                        weakSelf.odata_id = odata_id;
                        [weakSelf submitAction];
                        break;
                    }
                }
            }
            
        } failure:^(NSError *error) {
        }];
    }
    
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
                        if (weakSelf.didRefreshVlanBlock) {
                            weakSelf.didRefreshVlanBlock(result14, odata_id);
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
