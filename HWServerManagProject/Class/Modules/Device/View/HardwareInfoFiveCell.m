//
//  HardwareInfoOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoFiveCell.h"
#import "DeviceDetailListCell.h"
#import "HardwareInfoTwoSectionHeaderView.h"
#import "DeviceDetailListTwoCell.h"
#import "AddListCell.h"
#import "ListStateStatusCell.h"

@interface HardwareInfoFiveCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HardwareInfoFiveCell {
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
        [_tableView registerNib:[UINib nibWithNibName:@"ListStateStatusCell" bundle:nil] forCellReuseIdentifier:@"ListStateStatusCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListTwoCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListTwoCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBCOLOR(245, 242, 248);
        
    }
    
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataArray = [NSMutableArray new];
    leftArray = @[@"",
                  LocalString(@"hardware_storage_label_name"),
                  LocalString(@"hardware_storage_label_firmware_version"),
//                  LocalString(@"hardware_storage_label_support_ext_device"),
                  LocalString(@"hardware_storage_label_support_raid_level"),
//                  LocalString(@"hardware_storage_label_mode"),
                  LocalString(@"hardware_storage_label_configure_version"),
                  LocalString(@"hardware_storage_label_memory_size_MB"),
                  LocalString(@"hardware_storage_label_speed"),
                  LocalString(@"hardware_storage_label_sas_addr"),
                  LocalString(@"hardware_storage_label_stripe_range"),
//                  LocalString(@"hardware_storage_label_cache_pinned"),
                  LocalString(@"hardware_storage_label_maintain_pd_fail_history"),
                  LocalString(@"hardware_storage_label_copy_back_state"),
                  LocalString(@"hardware_storage_label_smart_copy_back_state"),
                  LocalString(@"hardware_storage_label_JOBD_state"),
                  LocalString(@"hardware_storage_label_bbu_name"),
                  LocalString(@"hardware_storage_label_bbu_state"),
                  LocalString(@"hardware_storage_label_volumes"),
                  LocalString(@"hardware_storage_label_disk")];


    [self.tableView reloadData];
    
    noDataView = [NoDataView createFromBundle];
    [self.contentView addSubview:noDataView];
    noDataView.center = self.tableView.center;
    noDataView.hidden = YES;
    
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
    if (section == 0) {
        return 50;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HardwareInfoTwoSectionHeaderView *secview = [[[NSBundle mainBundle] loadNibNamed:@"HardwareInfoTwoSectionHeaderView" owner:nil options:nil] lastObject];
//    secview.backgroundColor = [UIColor whiteColor];
    secview.clipsToBounds = YES;

//    NSDictionary *dic = self.dataArray[section];
//    NSArray *StorageControllers = dic[@"StorageControllers"];
//    NSDictionary *StorageController = nil;
//    if (StorageControllers.isSureArray && StorageControllers.count > 0) {
//        StorageController = [StorageControllers firstObject];
//    } else {
//        return secview;
//    }
//    NSDictionary *status = StorageController[@"Status"];
//    secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
//    if (status.isSureDictionary) {
//        NSString *state = status[@"State"];
//        if (state.isSureString && [state isEqualToString:@"Enabled"]) {
//            secview.title1Label.text = LocalString(@"resource_state_enabled");
//            secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
//        } else if (state.isSureString && [state isEqualToString:@"Disabled"]) {
//            secview.title1Label.text = LocalString(@"resource_state_disabled");
//            secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
//        }  else if (state.isSureString && [state isEqualToString:@"Absent"]) {
//            secview.title1Label.text = LocalString(@"resource_state_absent");
//            secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
//        } else {
//            secview.title1Label.text = @"";
//        }
//    } else {
//        secview.title1Label.text = @"";
//    }
    
//    secview.titleLabel.text = [NSString stringWithFormat:@"%@",StorageController[@"Name"]];
    secview.titleLabel.text = LocalString(@"storage_only_support_raid");

    
    return secview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tempv = [UIView new];
    tempv.backgroundColor = [UIColor clearColor];
    return tempv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
    if (indexPath.section < self.dataArray.count) {
    } else {
        return cell;
    }
    NSDictionary *dic = self.dataArray[indexPath.section];
   
    cell.titleLabel.text = leftArray[indexPath.row];
    cell.contentLabel.text = @"-";
    
    NSArray *StorageControllers = dic[@"StorageControllers"];
    NSDictionary *StorageController = nil;
    if (StorageControllers.isSureArray && StorageControllers.count > 0) {
        StorageController = [StorageControllers firstObject];
    } else {
        return cell;
    }
    
    switch (indexPath.row) {
        case 0: {
            ListStateStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListStateStatusCell"];
            NSDictionary *status = StorageController[@"Status"];
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
            if (status.isSureDictionary) {
                NSString *health = status[@"Health"];
                if (health.isSureString) {
                    if ([health isEqualToString:@"OK"]) {
                        cell.contentLabel.text = LocalString(@"ok");
                        cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
                    } else  if ([health isEqualToString:@"Warning"]) {
                        cell.contentLabel.text = LocalString(@"warning");
                        cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
                        
                    } else {
                        cell.contentLabel.text = LocalString(@"critical");
                        cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
                    }
                }
                
            } else {
                cell.contentLabel.text = @"";
                cell.iconIMV.image = nil;
            }
            
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",StorageController[@"Name"]];

            return cell;
        }
            
            break;
        case 1: {
            NSString *tempmodel = StorageController[@"Model"];
            if (tempmodel.isNoNull) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",tempmodel];
            }
        }
            
            break;
        case 2:{
            NSString *tempvalue = StorageController[@"FirmwareVersion"];
            if (tempvalue.isNoNull) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",tempvalue];
            }
        }
            break;

        case 3: {
            
            NSDictionary *Oem = StorageController[@"Oem"];
            if (Oem.isSureDictionary) {
                NSDictionary *Huawei = Oem[@"Huawei"];
                if (Huawei.isSureDictionary) {
                    NSArray *SupportedRAIDLevels = Huawei[@"SupportedRAIDLevels"];
                    if (SupportedRAIDLevels.isSureArray) {
                        NSMutableString *str = [NSMutableString new];
                        for (NSString *item in SupportedRAIDLevels) {
                            [str appendFormat:@"%@,",[item stringByReplacingOccurrencesOfString:@"RAID" withString:@""]];
                        }
                        if (str.length > 0) {
                            [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
                            cell.contentLabel.text = [NSString stringWithFormat:@"RAID(%@)",str];
                        } else {
                            cell.contentLabel.text = [NSString stringWithFormat:@"-"];

                        }
                    }
                }
            }

        }
            break;

        case 4: {
            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *tempvalue = huawei[@"ConfigurationVersion"];
                    if (tempvalue.isNoNull) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@",tempvalue];
                    }
                }
            }
        }
            break;
        case 5: {
            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *tempvalue = huawei[@"MemorySizeMiB"];
                    if (tempvalue.isNoNull) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@MB",tempvalue];
                    }
                }
            }
        }
            break;
        case 6: {
            NSString *tempvalue = StorageController[@"SpeedGbps"];
            if (tempvalue.isNoNull) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@GB",tempvalue];
            }
        }
            break;
        case 7: {
            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *tempvalue = huawei[@"SASAddress"];
                    if (tempvalue.isNoNull) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@",huawei[@"SASAddress"]];
                    }
                }
            }
            
        }
            break;
        case 8: {
            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *tempvalue1 = huawei[@"MaxStripeSizeBytes"];
                    NSString *tempvalue2 = huawei[@"MinStripeSizeBytes"];

                    NSString *MaxStripeSizeBytes = [NSString stringWithFormat:@"%@",tempvalue1.isNoNull?tempvalue1:@""];
                    NSString *MinStripeSizeBytes = [NSString stringWithFormat:@"%@",tempvalue2.isNoNull?tempvalue2:@""];
                    
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",MinStripeSizeBytes.toMemoryBString,MaxStripeSizeBytes.toMemoryBString];

                }
            }
            
        }
            break;
        case 9: {
            
            DeviceDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
//            cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
            cell1.titleLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"-";
            
            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *MaintainPDFailHistory = huawei[@"MaintainPDFailHistory"];
                    if (MaintainPDFailHistory && ![MaintainPDFailHistory isKindOfClass:[NSNull class]]) {
                        
                        if (MaintainPDFailHistory.integerValue == 1) {
                            cell1.contentLabel.text = LocalString(@"resource_state_enabled");
                        } else {
                            cell1.contentLabel.text = LocalString(@"resource_state_disabled");
                        }
                    }
                    
                }
            }
            return cell1;
        }
            break;
            
        case 10: {
            
            DeviceDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
//            cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
            cell1.titleLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"-";

            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    NSString *CopyBackState = huawei[@"CopyBackState"];
                    if (CopyBackState && ![CopyBackState isKindOfClass:[NSNull class]]) {
                        
                        if (CopyBackState.integerValue == 1) {
                            cell1.contentLabel.text = LocalString(@"resource_state_enabled");
                        } else {
                            cell1.contentLabel.text = LocalString(@"resource_state_disabled");
                        }
                    }
                    
                }
            }
            return cell1;
        }
            break;
            
        case 11: {
            
            DeviceDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
            cell1.titleLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"-";

            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    NSString *SmarterCopyBackState = huawei[@"SmarterCopyBackState"];
                    if (SmarterCopyBackState && ![SmarterCopyBackState isKindOfClass:[NSNull class]]) {
                        
                        if (SmarterCopyBackState.integerValue == 1) {
                            cell1.contentLabel.text = LocalString(@"resource_state_enabled");
                        } else {
                            cell1.contentLabel.text = LocalString(@"resource_state_disabled");
                        }
                    }
                    
                }
            }
            return cell1;
        }
            break;
            
        case 12: {
            
            DeviceDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
//            cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
            cell1.titleLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"-";

            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    NSString *JBODState = huawei[@"JBODState"];
                    if (JBODState && ![JBODState isKindOfClass:[NSNull class]]) {
                        
                        if (JBODState.integerValue == 1) {
                            cell1.contentLabel.text = LocalString(@"resource_state_enabled");
                        } else {
                            cell1.contentLabel.text = LocalString(@"resource_state_disabled");
                        }
                    }
                    
                }
            }
            return cell1;
        }
            break;
            
        case 13: {
            cell.contentLabel.text = @"-";

            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    NSString *CapacitanceName = huawei[@"CapacitanceName"];
                    if (CapacitanceName && ![CapacitanceName isKindOfClass:[NSNull class]]) {
                        cell.contentLabel.text = CapacitanceName;
                    }
                }
            }

            
        }
            break;
            
        case 14: {
            
            DeviceDetailListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
            cell1.titleLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"-";

            NSDictionary *oem = StorageController[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    NSDictionary *capacitanceStatus = huawei[@"CapacitanceStatus"];
                    if (capacitanceStatus.isSureDictionary) {
                        NSString *health = capacitanceStatus[@"Health"];
                        if (health.isSureString) {
                            if ([health isEqualToString:@"OK"]) {
                                cell1.contentLabel.text = LocalString(@"ok");
                            } else  if ([health isEqualToString:@"Warning"]) {
                                cell1.contentLabel.text = LocalString(@"warning");
                            } else {
                                cell1.contentLabel.text = LocalString(@"critical");
                            }
                        } else {
                            cell.contentLabel.text = @"";
                        }
                    } else {
                        cell.contentLabel.text = @"";
                    }
                    
                 }
             }
            return cell1;
        }
            break;
        case 15: {
            
            AddListCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
            cell1.leftLabel.text = leftArray[indexPath.row];
            cell1.contentLabel.text = @"";
           
            return cell1;
        }
            break;
        case 16: {
            
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
    if (indexPath.row == 15) {
        if (self.didHardwareLogicalDriveBlock) {
            self.didHardwareLogicalDriveBlock(self.dataArray[indexPath.section]);
        }
    } else if (indexPath.row == 16) {
        if (self.didHardwareDriveBlock) {
            self.didHardwareDriveBlock(self.dataArray[indexPath.section]);
        }
    }
}



- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    //存储
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Storages",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]] && Members.count > 0) {
            
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
                        [weakSelf.dataArray addObject:result14];
                        if (weakSelf.dataArray.count == Members.count) {
                            [weakSelf.tableView.mj_header endRefreshing];
                            [weakSelf.tableView reloadData];
                            if (weakSelf.didHardwareInfoFiveBlock) {
                                weakSelf.didHardwareInfoFiveBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                                [weakSelf showNoData];
                            }
                        }
                        
                        
                    } failure:^(NSError *error) {
                        [weakSelf.tableView.mj_header endRefreshing];
                        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
                        [weakSelf.tableView reloadData];
                        if (weakSelf.didHardwareInfoFiveBlock) {
                            weakSelf.didHardwareInfoFiveBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                        }
                    }];
                } else {
                    [weakSelf.tableView.mj_header endRefreshing];
                    if (weakSelf.didHardwareInfoFiveBlock) {
                        weakSelf.didHardwareInfoFiveBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                        [weakSelf showNoData];
                    }
                }
            }
        } else {
            [weakSelf showNoData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        if (weakSelf.didHardwareInfoFiveBlock) {
            weakSelf.didHardwareInfoFiveBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
            [weakSelf showNoData];
        }
        
    }];
    
}

@end
