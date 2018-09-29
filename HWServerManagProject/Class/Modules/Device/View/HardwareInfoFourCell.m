//
//  HardwareInfoOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoFourCell.h"
#import "DeviceDetailListCell.h"
#import "HardwareInfoTwoSectionHeaderView.h"
#import "AddListCell.h"
#import "NetPortListViewController.h"

@interface HardwareInfoFourCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HardwareInfoFourCell  {
    NoDataView *noDataView;
    NSArray *leftArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBCOLOR(245, 242, 248);
        
    }
    
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataArray = [NSMutableArray new];
    leftArray = @[LocalString(@"hardware_network_adapter_label_manufacturer"),
                  LocalString(@"hardware_network_adapter_label_model"),
                  LocalString(@"hardware_network_adapter_label_chip_manufacturer"),
                  LocalString(@"hardware_network_adapter_label_chip_model"),
                  LocalString(@"hardware_cpu_label_position"),
                  LocalString(@"hardware_network_adapter_label_ports")];

    [self.tableView reloadData];
    
    noDataView = [NoDataView createFromBundle];
    [self.contentView addSubview:noDataView];
    noDataView.center = self.tableView.center;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    [weakSelf getData];
}

- (void)showNoData {
    [MBProgressHUD hideHUDForView:self.contentView animated:YES];
    if (self.dataArray.count == 0) {
        noDataView.hidden = NO;
    } else {
        noDataView.hidden = YES;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return leftArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HardwareInfoTwoSectionHeaderView *secview = [[[NSBundle mainBundle] loadNibNamed:@"HardwareInfoTwoSectionHeaderView" owner:nil options:nil] lastObject];
    NSDictionary *dic = self.dataArray[section];
    NSDictionary *status = dic[@"Status"];
    secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
    if (status.isSureDictionary) {
        NSString *health = status[@"Health"];
        if (health.isSureString) {
            if ([health isEqualToString:@"OK"]) {
                secview.title1Label.text = LocalString(@"ok");
                secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
            } else  if ([health isEqualToString:@"Warning"]) {
                secview.title1Label.text = LocalString(@"warning");
                secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
            } else {
                secview.title1Label.text = LocalString(@"critical");
                secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
            }
        } else {
            secview.title1Label.text = @"";
            secview.iconIMV.image = nil;
        }
    } else {
        secview.title1Label.text = @"";
        secview.iconIMV.image = nil;
    }
    
    NSDictionary *oem = dic[@"Oem"];
    if (oem.isSureDictionary) {
        NSDictionary *huawei = oem[@"Huawei"];
        if (huawei.isSureDictionary) {
            secview.titleLabel.text = [NSString stringWithFormat:@"%@",huawei[@"Name"]];
        }
    }
    
    return secview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tempv = [UIView new];
    tempv.backgroundColor = [UIColor clearColor];
    return tempv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
    NSDictionary *dic = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = leftArray[indexPath.row];
    cell.contentLabel.text = @"-";
    switch (indexPath.row) {
        case 0: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",huawei[@"CardManufacturer"]];
                }
            }
        }
            break;
        case 1: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",huawei[@"CardModel"]];
                }
            }
        }
            break;
        case 2: {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"Manufacturer"]];
        }
            break;
        case 3:
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"Model"]];
            break;
        case 4: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",huawei[@"Position"]];
                }
            }
        }            break;
        case 5: {
            AddListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
            cell1.leftLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"";

            return cell1;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        NSDictionary *dic = self.dataArray[indexPath.section];
        NSDictionary *NetworkPorts = dic[@"NetworkPorts"];
        if (NetworkPorts.isSureDictionary) {
            NSString *odata_id = NetworkPorts[@"@odata.id"];
            NetPortListViewController *vc = [NetPortListViewController new];
            vc.odata_id = odata_id;
            [self.controller.navigationController pushViewController:vc animated:YES];

        }
        
    }
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    //网卡
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/NetworkAdapters",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
           
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        
                        [weakSelf.dataArray addObject:result14];
                        if (weakSelf.dataArray.count == Members.count) {
                            [weakSelf.tableView.mj_header endRefreshing];
                            [weakSelf.tableView reloadData];
                            if (weakSelf.didHardwareInfoFourBlock) {
                                weakSelf.didHardwareInfoFourBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                            }
                            [weakSelf showNoData];
                        }
                    } failure:^(NSError *error) {
                        [weakSelf.tableView.mj_header endRefreshing];
                        [weakSelf.tableView reloadData];
                        [weakSelf showNoData];
                        if (weakSelf.didHardwareInfoFourBlock) {
                            weakSelf.didHardwareInfoFourBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                        }
                    }];
                } else {
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.tableView reloadData];
                    [weakSelf showNoData];
                    if (weakSelf.didHardwareInfoFourBlock) {
                        weakSelf.didHardwareInfoFourBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf showNoData];
    }];
}

@end
