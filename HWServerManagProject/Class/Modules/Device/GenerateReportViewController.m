//
//  GenerateReportViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/1.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "GenerateReportViewController.h"
#import "AddListTwoCell.h"
#import "ReportShowViewController.h"
#import "StoragesDataGetManager.h"

@interface GenerateReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *submitBtn;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dataResultArray;
//@property (strong, nonatomic) NSMutableArray *collectStatusArray;
@property (assign, nonatomic) NSInteger CPUDataIndex;
@property (assign, nonatomic) NSInteger memoryDataIndex;
@property (assign, nonatomic) NSInteger storagesDataIndex;
@property (assign, nonatomic) NSInteger firmwareDataIndex;

@property (strong, nonatomic) StoragesDataGetManager *storagesDataGetManager;

@end

@implementation GenerateReportViewController {
    NSArray *titleArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)dataResultArray {
    if (!_dataResultArray) {
        _dataResultArray = [NSMutableArray new];
    }
    return _dataResultArray;
}

//- (NSMutableArray *)collectStatusArray {
//    if (!_collectStatusArray) {
//        _collectStatusArray = [NSMutableArray new];
//    }
//    return _collectStatusArray;
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF1F1F1);
    self.title = LocalString(@"toreport");
    [self createBackBtn];
    titleArray = @[LocalString(@"reportsysinfo"),LocalString(@"reportcpu"),LocalString(@"reportmemory"),LocalString(@"reportstorage"),LocalString(@"devicedetailfirmware"),LocalString(@"reportnetwork"),LocalString(@"reporthealthsta")];
    [self.dataArray addObjectsFromArray:@[@(YES),@(YES),@(YES),@(YES),@(YES),@(YES),@(YES)]];
//    [self.dataResultArray addObjectsFromArray:@[self.htmlStr1,@"",@"",@"",@"",@"",@""]];
//    [self.collectStatusArray addObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    footerView.backgroundColor = [UIColor clearColor];
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"reportbtn") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submitBtn];
    self.tableView.tableFooterView = footerView;
    [self.submitBtn addTarget:self action:@selector(submit1Action) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
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

- (void)submit1Action {
    [self.dataResultArray removeAllObjects];
    [self.dataResultArray addObject:self.htmlStr1];
    
    NSInteger tempnum = 0;
    for (NSNumber *valussss in self.dataArray) {
        if (valussss.boolValue == YES) {
            tempnum ++;
        }
    }
    if (tempnum == 0) {
        return;
    }
    
    if ([self.dataArray[0] boolValue] == NO) {
        [self.dataResultArray removeAllObjects];
    }
    
//    BOOL isToSubmit = NO;
//    for (NSNumber *number in self.dataArray) {
//        if (number.boolValue == YES) {
//            isToSubmit = YES;
//            break;
//        }
//    }
//    if (!isToSubmit) {
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    for (NSInteger i = 0; i<self.collectStatusArray.count; i++) {
//        [self.collectStatusArray replaceObjectAtIndex:i withObject:@(NO)];
//    }
//    [self.collectStatusArray replaceObjectAtIndex:0 withObject:@(YES)];
    
//    if ([self.dataArray[0] boolValue] == YES) {
//        [self.dataResultArray replaceObjectAtIndex:0 withObject:self.htmlStr1];
//        [self getFinsih];
//    } else {
//        [self.dataResultArray replaceObjectAtIndex:0 withObject:@""];
//    }
//
    if ([self.dataArray[1] boolValue] == YES) {
        [self getCPUData];
    } else  if ([self.dataArray[2] boolValue] == YES) {
        [self getMemoryData];
    } else if ([self.dataArray[3] boolValue] == YES) {
        [self getStoragesData];
    } else if ([self.dataArray[4] boolValue] == YES) {
        [self getFirmwareData];
    } else if ([self.dataArray[5] boolValue] == YES) {
        [self getEthernetInterfacesData];
    } else if ([self.dataArray[6] boolValue] == YES) {
        [self getHealthData];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getFinsih];
    }
    
    
}

- (void)getCPUData {
    
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Processors",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        if (Members.isSureArray && Members.count > 0) {
            
            NSMutableString *tempstr1 = [NSMutableString new];
            [tempstr1 appendString:@"<div><h3>CPU</h3>"];

            weakSelf.CPUDataIndex = 0;
            [weakSelf getCPUDataIndex:Members contentString:tempstr1];
        } else {
            [weakSelf.dataResultArray addObject:@""];
            if ([weakSelf.dataArray[2] boolValue] == YES) {
                [weakSelf getMemoryData];
            } else if ([weakSelf.dataArray[3] boolValue] == YES) {
                [weakSelf getStoragesData];
            } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                [weakSelf getFirmwareData];
            } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                [weakSelf getEthernetInterfacesData];
            } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                [weakSelf getHealthData];
            } else {
                [weakSelf getFinsih];
            }
        }
        
        
        
    } failure:^(NSError *error) {
//        [weakSelf.collectStatusArray replaceObjectAtIndex:1 withObject:@(YES)];
        [weakSelf getFinsih];
//        [weakSelf.dataResultArray addObject:@""];
//         [weakSelf getMemoryData];
    }];
}

- (void)getCPUDataIndex:(NSArray *)members contentString:(NSMutableString *)tempstr1 {
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = members[self.CPUDataIndex];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            weakSelf.CPUDataIndex ++;
            [tempstr1 appendFormat:@"<table>"];
            
            NSDictionary *status = result14[@"Status"];
            if (status.isSureDictionary) {
                NSString *health = status[@"Health"];
                if (health.isSureString) {
                    if ([health isEqualToString:@"OK"]) {
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"Name"],LocalString(@"ok")];
                    } else  if ([health isEqualToString:@"Warning"]) {
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"Name"],LocalString(@"warning")];

                    } else {
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"Name"],LocalString(@"critical")];
                    }
                } else {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"Name"],@""];
                }
            } else {
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"Name"],@""];
            }
            
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_manufacturer"),result14[@"Manufacturer"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_model"),result14[@"Model"]];
            NSDictionary *ProcessorId = result14[@"ProcessorId"];
            if (ProcessorId.isSureDictionary) {
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_processor_id"),ProcessorId[@"IdentificationRegisters"]];
            } else {
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_processor_id"),@""];
            }
            
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MHz</td></tr>",LocalString(@"hardware_cpu_label_speed_MHZ"),result14[@"MaxSpeedMHz"]];
            
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@ Cores/%@ Threads</td></tr>",LocalString(@"hardware_cpu_label_cores_and_threads"),result14[@"TotalCores"],result14[@"TotalThreads"]];
            
            NSString *oemhuaweicachekib = @"";
            NSString *oemhuaweipartNumber = @"";
            
            NSDictionary *oem = result14[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    oemhuaweicachekib = [NSString stringWithFormat:@"%@/%@/%@ KB",huawei[@"L1CacheKiB"],huawei[@"L2CacheKiB"],huawei[@"L3CacheKiB"]];
                    oemhuaweipartNumber = huawei[@"PartNumber"];
                    oemhuaweipartNumber = oemhuaweipartNumber.objectWitNoNullWithNA;
                }
            }
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_L123_cache"),oemhuaweicachekib];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_part_no"),oemhuaweipartNumber];
            
            [tempstr1 appendString:@"</table>"];
            if (weakSelf.CPUDataIndex == members.count) {
                [tempstr1 appendString:@"</div>"];
//                [weakSelf.collectStatusArray replaceObjectAtIndex:1 withObject:@(YES)];
//                [weakSelf.dataResultArray replaceObjectAtIndex:1 withObject:tempstr1];
//                if (weakSelf.dataResultArray.count < 2) {
                    [weakSelf.dataResultArray addObject:tempstr1];
//                } else {
//                    [weakSelf.dataResultArray replaceObjectAtIndex:1 withObject:tempstr1];
//                }
//                [weakSelf getFinsih];
//                [weakSelf getMemoryData];
                if ([weakSelf.dataArray[2] boolValue] == YES) {
                    [weakSelf getMemoryData];
                } else if ([weakSelf.dataArray[3] boolValue] == YES) {
                    [weakSelf getStoragesData];
                } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                    [weakSelf getFirmwareData];
                } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                    [weakSelf getEthernetInterfacesData];
                } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                    [weakSelf getHealthData];
                } else {
                    [weakSelf getFinsih];
                }
            } else {
                [weakSelf getCPUDataIndex:members contentString:tempstr1];
            }
            
        } failure:^(NSError *error) {
//            weakSelf.CPUDataIndex ++;
//            if (weakSelf.CPUDataIndex == members.count) {
//                [tempstr1 appendString:@"</div>"];
////                [weakSelf.collectStatusArray replaceObjectAtIndex:1 withObject:@(YES)];
////                [weakSelf.dataResultArray replaceObjectAtIndex:1 withObject:tempstr1];
//                if (weakSelf.dataResultArray.count < 2) {
//                    [weakSelf.dataResultArray addObject:tempstr1];
//                } else {
//                    [weakSelf.dataResultArray replaceObjectAtIndex:1 withObject:tempstr1];
//                }
                [weakSelf getFinsih];
//                [weakSelf getMemoryData];
//            } else {
//                [weakSelf getCPUDataIndex:members contentString:tempstr1];
//            }
        }];
    } else {
//        [weakSelf.collectStatusArray replaceObjectAtIndex:1 withObject:@(YES)];
//        [weakSelf getFinsih];
//        if (weakSelf.dataResultArray.count < 2) {
            [weakSelf.dataResultArray addObject:tempstr1];
//        } else {
//            [weakSelf.dataResultArray replaceObjectAtIndex:1 withObject:tempstr1];
//        }
//        [weakSelf getMemoryData];
        if ([weakSelf.dataArray[2] boolValue] == YES) {
            [weakSelf getMemoryData];
        } else if ([weakSelf.dataArray[3] boolValue] == YES) {
            [weakSelf getStoragesData];
        } else if ([weakSelf.dataArray[4] boolValue] == YES) {
            [weakSelf getFirmwareData];
        } else if ([weakSelf.dataArray[5] boolValue] == YES) {
            [weakSelf getEthernetInterfacesData];
        } else if ([weakSelf.dataArray[6] boolValue] == YES) {
            [weakSelf getHealthData];
        } else {
            [weakSelf getFinsih];
        }
    }
}

- (void)getMemoryData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/MemoryView",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Information = result[@"Information"];
        NSString *nextLink = result[@"Members@odata.nextLink"];
        if (Information.isSureArray && Information.count > 0) {
            NSMutableString *tempstr1 = [NSMutableString new];
            [tempstr1 appendFormat:@"<div><h3>%@</h3>",LocalString(@"healthmemory")];
            
            for (NSDictionary *result14 in Information) {
                
                NSDictionary *status = result14[@"Status"];
                if (status.isSureDictionary) {
                    NSString *state = status[@"State"];
                    if (state.isSureString && ![state isEqualToString:@"Absent"]) {
                        
                        [tempstr1 appendFormat:@"<table>"];
                        
                        NSDictionary *status = result14[@"Status"];
                        if (status.isSureDictionary) {
                            NSString *health = status[@"Health"];
                            if (health.isSureString) {
                                if ([health isEqualToString:@"OK"]) {
                                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"ok")];
                                } else  if ([health isEqualToString:@"Warning"]) {
                                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"warning")];

                                } else {
                                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"critical")];
                                }
                            } else {
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],@""];
                            }
                            
                        } else {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],@""];
                        }
                        
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_manufacturer"),result14[@"Manufacturer"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_serial_no"),result14[@"SerialNumber"]];
                        NSString *partnumber = result14[@"PartNumber"];
                        if (partnumber && ![partnumber isKindOfClass:[NSNull class]]) {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_part_no"),result14[@"PartNumber"]];
                        } else {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_part_no"),@"N/A"];

                        }
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_power_label_model"),result14[@"MemoryDeviceType"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MB</td></tr>",LocalString(@"hardware_memo_label_capacity"),result14[@"CapacityMiB"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MHz</td></tr>",LocalString(@"hardware_memo_label_speed"),result14[@"OperatingSpeedMhz"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@rank</td></tr>",LocalString(@"hardware_memo_label_width_bit"),result14[@"RankCount"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@bit</td></tr>",LocalString(@"hardware_memo_label_rank_count"),result14[@"OperatingSpeedMhz"]];
                        
                        NSString *minVoltageMillivolt = result14[@"MinVoltageMillivolt"];
                        NSString *technology = result14[@"Technology"];
                        NSString *position = result14[@"Position"];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),minVoltageMillivolt.objectWitNoNullWithNA];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),technology.objectWitNoNullWithNA];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),position.objectWitNoNullWithNA];
                        
                        [tempstr1 appendString:@"</table>"];
                        
                    }
                }
                
                
            }
            
            //下一页
            if (nextLink && nextLink.isSureString && nextLink.length > 0) {
                
                [weakSelf loadMemoryData:nextLink contentString:tempstr1];
                
            } else {
                
                [weakSelf.dataResultArray addObject:tempstr1];
                if ([weakSelf.dataArray[3] boolValue] == YES) {
                    [weakSelf getStoragesData];
                } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                    [weakSelf getFirmwareData];
                } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                    [weakSelf getEthernetInterfacesData];
                } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                    [weakSelf getHealthData];
                } else {
                    [weakSelf getFinsih];
                }
            }
            
            
            
            
        } else {
//            [weakSelf.collectStatusArray replaceObjectAtIndex:2 withObject:@(YES)];
//            [weakSelf getFinsih];
            [weakSelf.dataResultArray addObject:@""];
//            [weakSelf getStoragesData];
            if ([weakSelf.dataArray[3] boolValue] == YES) {
                [weakSelf getStoragesData];
            } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                [weakSelf getFirmwareData];
            } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                [weakSelf getEthernetInterfacesData];
            } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                [weakSelf getHealthData];
            } else {
                [weakSelf getFinsih];
            }

        }
        
        
        
    } failure:^(NSError *error) {
//        [weakSelf.collectStatusArray replaceObjectAtIndex:2 withObject:@(YES)];
        [weakSelf getFinsih];
//        [weakSelf.dataResultArray addObject:@""];
//        [weakSelf getStoragesData];
    }];
}


- (void)loadMemoryData:(NSString *)nextLink contentString:(NSMutableString *)tempstr1 {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:[nextLink substringFromIndex:1],[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Information = result[@"Information"];
        NSString *nextLink = result[@"Members@odata.nextLink"];
        if (Information.isSureArray && Information.count > 0) {
            NSMutableString *tempstr1 = [NSMutableString new];
            [tempstr1 appendFormat:@"<div><h3>%@</h3>",LocalString(@"healthmemory")];
            
            for (NSDictionary *result14 in Information) {
                
                NSDictionary *status = result14[@"Status"];
                if (status.isSureDictionary) {
                    NSString *state = status[@"State"];
                    if (state.isSureString && ![state isEqualToString:@"Absent"]) {
                        
                        [tempstr1 appendFormat:@"<table>"];
                        
                        NSDictionary *status = result14[@"Status"];
                        if (status.isSureDictionary) {
                            NSString *health = status[@"Health"];
                            if (health.isSureString) {
                                if ([health isEqualToString:@"OK"]) {
                                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"ok")];
                                } else  if ([health isEqualToString:@"Warning"]) {
                                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"warning")];
                                    
                                } else {
                                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"critical")];
                                }
                            } else {
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],@""];
                            }
                            
                        } else {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],@""];
                        }
                        
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_manufacturer"),result14[@"Manufacturer"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_serial_no"),result14[@"SerialNumber"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_part_no"),result14[@"PartNumber"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_power_label_model"),result14[@"MemoryDeviceType"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MB</td></tr>",LocalString(@"hardware_memo_label_capacity"),result14[@"CapacityMiB"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MHz</td></tr>",LocalString(@"hardware_memo_label_speed"),result14[@"OperatingSpeedMhz"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@rank</td></tr>",LocalString(@"hardware_memo_label_width_bit"),result14[@"RankCount"]];
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@bit</td></tr>",LocalString(@"hardware_memo_label_rank_count"),result14[@"OperatingSpeedMhz"]];
                        
                        NSDictionary *oem = result14[@"Oem"];
                        if (oem.isSureDictionary) {
                            NSDictionary *huawei = oem[@"Huawei"];
                            if (huawei.isSureDictionary) {
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),huawei[@"MinVoltageMillivolt"]];
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),huawei[@"Technology"]];
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),huawei[@"Position"]];
                                
                            } else {
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),@""];
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),@""];
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),@""];
                                
                            }
                            
                        } else {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),@""];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),@""];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),@""];
                        }
                        
                        [tempstr1 appendString:@"</table>"];
                        
                    }
                }
                
                
            }
            
            //下一页
            if (nextLink && nextLink.isSureString && nextLink.length > 0) {
                
                [weakSelf loadMemoryData:nextLink contentString:tempstr1];
                
            } else {
                
                [weakSelf.dataResultArray addObject:tempstr1];
                if ([weakSelf.dataArray[3] boolValue] == YES) {
                    [weakSelf getStoragesData];
                } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                    [weakSelf getFirmwareData];
                } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                    [weakSelf getEthernetInterfacesData];
                } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                    [weakSelf getHealthData];
                } else {
                    [weakSelf getFinsih];
                }
            }
            
            
            
            
        } else {

            [weakSelf.dataResultArray addObject:tempstr1];
            if ([weakSelf.dataArray[3] boolValue] == YES) {
                [weakSelf getStoragesData];
            } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                [weakSelf getFirmwareData];
            } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                [weakSelf getEthernetInterfacesData];
            } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                [weakSelf getHealthData];
            } else {
                [weakSelf getFinsih];
            }
            
        }
        
    } failure:^(NSError *error) {
        [weakSelf getFinsih];
    }];
}

- (void)getMemoryDataIndex:(NSArray *)members contentString:(NSMutableString *)tempstr1 {
    NSDictionary *dic = members[self.memoryDataIndex];
    __weak typeof(self) weakSelf = self;
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            weakSelf.memoryDataIndex ++;
            [tempstr1 appendFormat:@"<table>"];
            
            NSDictionary *status = result14[@"Status"];
            if (status.isSureDictionary) {
                NSString *state = status[@"State"];
                if (state.isSureString && [state isEqualToString:@"Enabled"]) {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"resource_state_enabled")];
                } else {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"resource_state_disabled")];
                }
            } else {
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result14[@"DeviceLocator"],LocalString(@"resource_state_disabled")];
            }
            
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_manufacturer"),result14[@"Manufacturer"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_serial_no"),result14[@"SerialNumber"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_part_no"),result14[@"PartNumber"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_power_label_model"),result14[@"MemoryDeviceType"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MB</td></tr>",LocalString(@"hardware_memo_label_capacity"),result14[@"CapacityMiB"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@MHz</td></tr>",LocalString(@"hardware_memo_label_speed"),result14[@"OperatingSpeedMhz"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@rank</td></tr>",LocalString(@"hardware_memo_label_width_bit"),result14[@"RankCount"]];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@bit</td></tr>",LocalString(@"hardware_memo_label_rank_count"),result14[@"OperatingSpeedMhz"]];
            
            NSDictionary *oem = result14[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),huawei[@"MinVoltageMillivolt"]];
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),huawei[@"Technology"]];
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),huawei[@"Position"]];
                    
                } else {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),@""];
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),@""];
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),@""];

                }
                
            } else {
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@mV</td></tr>",LocalString(@"hardware_memo_label_min_voltage"),@""];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_memo_label_technology"),@""];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_cpu_label_position"),@""];
            }
            
            [tempstr1 appendString:@"</table>"];
            if (weakSelf.memoryDataIndex == members.count) {
                [tempstr1 appendString:@"</div>"];
//                [weakSelf.collectStatusArray replaceObjectAtIndex:2 withObject:@(YES)];
//                [weakSelf.dataResultArray replaceObjectAtIndex:2 withObject:tempstr1];
                if (weakSelf.dataResultArray.count < 3) {
                    [weakSelf.dataResultArray addObject:tempstr1];
                } else {
                    [weakSelf.dataResultArray replaceObjectAtIndex:2 withObject:tempstr1];

                }
//                [weakSelf getStoragesData];
                if ([weakSelf.dataArray[3] boolValue] == YES) {
                    [weakSelf getStoragesData];
                } else if ([weakSelf.dataArray[4] boolValue] == YES) {
                    [weakSelf getFirmwareData];
                } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                    [weakSelf getEthernetInterfacesData];
                } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                    [weakSelf getHealthData];
                } else {
                    [weakSelf getFinsih];
                }
            } else {
                [weakSelf getMemoryDataIndex:members contentString:tempstr1];
            }
            
        } failure:^(NSError *error) {
//            weakSelf.memoryDataIndex ++;
//            if (weakSelf.memoryDataIndex == members.count) {
//                [tempstr1 appendString:@"</div>"];
////                [weakSelf.collectStatusArray replaceObjectAtIndex:2 withObject:@(YES)];
////                [weakSelf.dataResultArray replaceObjectAtIndex:2 withObject:tempstr1];
                [weakSelf getFinsih];
//                if (weakSelf.dataResultArray.count < 3) {
//                    [weakSelf.dataResultArray addObject:tempstr1];
//                } else {
//                    [weakSelf.dataResultArray replaceObjectAtIndex:2 withObject:tempstr1];
//
//                }
//                [weakSelf getStoragesData];
//            } else {
//                [weakSelf getMemoryDataIndex:members contentString:tempstr1];
//            }
        }];
    } else {
//        [weakSelf.collectStatusArray replaceObjectAtIndex:2 withObject:@(YES)];
//        [weakSelf getFinsih];
//        if (weakSelf.dataResultArray.count < 3) {
            [weakSelf.dataResultArray addObject:tempstr1];
//        } else {
//            [weakSelf.dataResultArray replaceObjectAtIndex:2 withObject:tempstr1];
//
//        }
//        [weakSelf getStoragesData];
        if ([weakSelf.dataArray[3] boolValue] == YES) {
            [weakSelf getStoragesData];
        } else if ([weakSelf.dataArray[4] boolValue] == YES) {
            [weakSelf getFirmwareData];
        } else if ([weakSelf.dataArray[5] boolValue] == YES) {
            [weakSelf getEthernetInterfacesData];
        } else if ([weakSelf.dataArray[6] boolValue] == YES) {
            [weakSelf getHealthData];
        } else {
            [weakSelf getFinsih];
        }
    }
}

- (void)getStoragesData {
    //存储
    
    __weak typeof(self) weakSelf = self;

    self.storagesDataGetManager = [StoragesDataGetManager new];
    self.storagesDataGetManager.dataIndex = 0;
    [self.storagesDataGetManager getStoragesData:^(NSString *string) {
        if (string) {
            [weakSelf.dataResultArray addObject:string];
            if ([weakSelf.dataArray[4] boolValue] == YES) {
                [weakSelf getFirmwareData];
            } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                [weakSelf getEthernetInterfacesData];
            } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                [weakSelf getHealthData];
            } else {
                [weakSelf getFinsih];
            }
        } else {
            [weakSelf getFinsih];
        }
    }];

}

- (void)getStoragesDataIndex:(NSArray *)members contentString:(NSMutableString *)tempstr1 {
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = members[self.storagesDataIndex];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            weakSelf.storagesDataIndex ++;
            [tempstr1 appendFormat:@"<table>"];
            
            NSArray *StorageControllers = result14[@"StorageControllers"];
            NSDictionary *StorageController = nil;
            if (StorageControllers.isSureArray && StorageControllers.count > 0) {
                StorageController = [StorageControllers firstObject];
                
                NSDictionary *status = StorageController[@"Status"];
                if (status.isSureDictionary) {
                    NSString *health = status[@"Health"];
                    if (health.isSureString) {
                        if ([health isEqualToString:@"OK"]) {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],LocalString(@"ok")];

                        } else  if ([health isEqualToString:@"Warning"]) {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],LocalString(@"warning")];

                        } else {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],LocalString(@"critical")];
                        }
                    }
                    
                } else {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],@""];
                }
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_name"),StorageController[@"Model"]];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_power_label_firmware_version"),StorageController[@"FirmwareVersion"]];
                
                NSString *RAIDtempstr = @"";
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
                                RAIDtempstr = [NSString stringWithFormat:@"RAID(%@) ",str];
                            } else {
                                RAIDtempstr = [NSString stringWithFormat:@"-"];
                            }
                            
                        }
                    }
                }
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_support_raid_level"),RAIDtempstr];
                
                NSString *ConfigurationVersion = @"";
                NSString *MemorySizeMiB = @"";
                NSString *SASAddress = @"";
                NSString *MinMaxStripeSizeBytes = @"";
                NSString *MaintainPDFailHistoryState = @"";
                NSString *CopyBackStateState = @"";
                NSString *SmarterCopyBackStateState = @"";
                NSString *JBODStateState = @"";
                NSString *CapacitanceName = @"";
                NSString *CapacitanceStatus = @"";
                NSDictionary *oem = StorageController[@"Oem"];
                if (oem.isSureDictionary) {
                    NSDictionary *huawei = oem[@"Huawei"];
                    if (huawei.isSureDictionary) {
                        
                        ConfigurationVersion = huawei[@"ConfigurationVersion"];
                        MemorySizeMiB = [NSString stringWithFormat:@"%@MB",huawei[@"MemorySizeMiB"]];
                        SASAddress = [NSString stringWithFormat:@"%@",huawei[@"SASAddress"]];
                        
                        NSString *MaxStripeSizeBytes = [NSString stringWithFormat:@"%@",huawei[@"MaxStripeSizeBytes"]];
                        NSString *MinStripeSizeBytes = [NSString stringWithFormat:@"%@",huawei[@"MinStripeSizeBytes"]];
                        
                        MinMaxStripeSizeBytes = [NSString stringWithFormat:@"%@-%@",MinStripeSizeBytes.toMemoryBString,MaxStripeSizeBytes.toMemoryBString];
                        
                        NSString *MaintainPDFailHistory = huawei[@"MaintainPDFailHistory"];
                        if (MaintainPDFailHistory && ![MaintainPDFailHistory isKindOfClass:[NSNull class]]) {
                            if (MaintainPDFailHistory.integerValue == 1) {
                                MaintainPDFailHistoryState = LocalString(@"resource_state_enabled");
                            } else {
                                MaintainPDFailHistoryState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        NSString *CopyBackState = huawei[@"CopyBackState"];
                        if (CopyBackState && ![CopyBackState isKindOfClass:[NSNull class]]) {
                            
                            if (CopyBackState.integerValue == 1) {
                                CopyBackStateState = LocalString(@"resource_state_enabled");
                            } else {
                                CopyBackStateState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        NSString *SmarterCopyBackState = huawei[@"SmarterCopyBackState"];
                        if (SmarterCopyBackState && ![SmarterCopyBackState isKindOfClass:[NSNull class]]) {
                            if (SmarterCopyBackState.integerValue == 1) {
                                SmarterCopyBackStateState = LocalString(@"resource_state_enabled");
                            } else {
                                SmarterCopyBackStateState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        
                        NSString *JBODState = huawei[@"JBODState"];
                        if (JBODState && ![JBODState isKindOfClass:[NSNull class]]) {
                            
                            if (JBODState.integerValue == 1) {
                                JBODStateState = LocalString(@"resource_state_enabled");
                            } else {
                                JBODStateState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        NSString *capacitanceName = huawei[@"CapacitanceName"];
                        if (capacitanceName && ![capacitanceName isKindOfClass:[NSNull class]]) {
                            CapacitanceName = capacitanceName;
                        }
                        
                        NSDictionary *capacitanceStatus = huawei[@"CapacitanceStatus"];
                        if (capacitanceStatus.isSureDictionary) {
                            NSString *health = capacitanceStatus[@"Health"];
                            if (health.isSureString) {
                                if ([health isEqualToString:@"OK"]) {
                                    CapacitanceStatus = LocalString(@"ok");
                                } else  if ([health isEqualToString:@"Warning"]) {
                                    CapacitanceStatus = LocalString(@"warning");
                                } else {
                                    CapacitanceStatus = LocalString(@"critical");
                                }
                            }
                        }
                        
                    }
                }
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_configure_version"),ConfigurationVersion];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_memory_size_MB"),MemorySizeMiB];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@GB</td></tr>",LocalString(@"hardware_storage_label_speed"),StorageController[@"SpeedGbps"]];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_sas_addr"),SASAddress];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_stripe_range"),MinMaxStripeSizeBytes];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_maintain_pd_fail_history"),MaintainPDFailHistoryState];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_copy_back_state"),CopyBackStateState];
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_smart_copy_back_state"),SmarterCopyBackStateState];
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_JOBD_state"),JBODStateState];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_bbu_name"),CapacitanceName];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_bbu_state"),CapacitanceStatus];
            }
            
            [tempstr1 appendString:@"</table>"];
            
            //逻辑盘列表，物理盘列表
            
            if (weakSelf.storagesDataIndex == members.count) {
                [tempstr1 appendString:@"</div>"];
                [weakSelf.dataResultArray addObject:tempstr1];
                if ([weakSelf.dataArray[4] boolValue] == YES) {
                    [weakSelf getFirmwareData];
                } else if ([weakSelf.dataArray[5] boolValue] == YES) {
                    [weakSelf getEthernetInterfacesData];
                } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                    [weakSelf getHealthData];
                } else {
                    [weakSelf getFinsih];
                }

            } else {
                [weakSelf getStoragesDataIndex:members contentString:tempstr1];
            }
            
        } failure:^(NSError *error) {

            [weakSelf getFinsih];

        }];
    } else {

        [weakSelf.dataResultArray addObject:tempstr1];

        if ([weakSelf.dataArray[4] boolValue] == YES) {
            [weakSelf getFirmwareData];
        } else if ([weakSelf.dataArray[5] boolValue] == YES) {
            [weakSelf getEthernetInterfacesData];
        } else if ([weakSelf.dataArray[6] boolValue] == YES) {
            [weakSelf getHealthData];
        } else {
            [weakSelf getFinsih];
        }
    }
}


- (void)getFirmwareData {
    //固件
    
    __weak typeof(self) weakSelf = self;
    
    [ABNetWorking getWithUrlWithAction:@"redfish/v1/UpdateService/FirmwareInventory" parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        if (Members && [Members isKindOfClass:[NSArray class]] && Members.count > 0) {
            NSMutableString *tempstr1 = [NSMutableString new];
            [tempstr1 appendFormat:@"<div><h3>%@</h3>",LocalString(@"devicedetailfirmware")];
            [tempstr1 appendFormat:@"<table>"];
            weakSelf.firmwareDataIndex = 0;
            [weakSelf getFirmwareDataIndex:Members contentString:tempstr1];
            
        }  else {
//            [weakSelf.collectStatusArray replaceObjectAtIndex:4 withObject:@(YES)];
//            [weakSelf getFinsih];
            [weakSelf.dataResultArray addObject:@""];
//            [weakSelf getEthernetInterfacesData];
            if ([weakSelf.dataArray[5] boolValue] == YES) {
                [weakSelf getEthernetInterfacesData];
            } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                [weakSelf getHealthData];
            } else {
                [weakSelf getFinsih];
            }

        }
        
    } failure:^(NSError *error) {
//        [weakSelf.collectStatusArray replaceObjectAtIndex:4 withObject:@(YES)];
        [weakSelf getFinsih];
    }];
}

- (void)getFirmwareDataIndex:(NSArray *)members contentString:(NSMutableString *)tempstr1 {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = members[self.firmwareDataIndex];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            weakSelf.firmwareDataIndex ++;
            NSString *tempname = result14[@"Name"];
//            if ([tempname isEqualToString:@"ActiveBMC"]) {
//                tempname = @"Active iBMC";
//            } else if ([tempname isEqualToString:@"BackupBMC"]) {
//                tempname = @"Backup iBMC";
//            } else if ([tempname isEqualToString:@"Bios"]) {
//                tempname = @"BIOS";
//            }
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",tempname,result14[@"Version"]];
            
            if (weakSelf.firmwareDataIndex == members.count) {
                [tempstr1 appendString:@"</table></div>"];
//                [weakSelf.collectStatusArray replaceObjectAtIndex:4 withObject:@(YES)];
//                if (weakSelf.dataResultArray.count < 5) {
                    [weakSelf.dataResultArray addObject:tempstr1];
//                } else {
//                    [weakSelf.dataResultArray replaceObjectAtIndex:4 withObject:tempstr1];
//                }
//                [weakSelf getEthernetInterfacesData];
                if ([weakSelf.dataArray[5] boolValue] == YES) {
                    [weakSelf getEthernetInterfacesData];
                } else if ([weakSelf.dataArray[6] boolValue] == YES) {
                    [weakSelf getHealthData];
                } else {
                    [weakSelf getFinsih];
                }
            } else {
                [weakSelf getFirmwareDataIndex:members contentString:tempstr1];
            }
            
        } failure:^(NSError *error) {
//            weakSelf.firmwareDataIndex ++;
//            if (weakSelf.firmwareDataIndex == members.count) {
//                [tempstr1 appendString:@"</table></div>"];
//                [weakSelf.collectStatusArray replaceObjectAtIndex:4 withObject:@(YES)];
//                [weakSelf.dataResultArray replaceObjectAtIndex:4 withObject:tempstr1];
                [weakSelf getFinsih];
//            } else {
//                [weakSelf getFirmwareDataIndex:members contentString:tempstr1];
//            }
        }];
    } else {
//        if (weakSelf.dataResultArray.count < 5) {
            [weakSelf.dataResultArray addObject:tempstr1];
//        } else {
//            [weakSelf.dataResultArray replaceObjectAtIndex:4 withObject:tempstr1];
//        }
//        [weakSelf getEthernetInterfacesData];
        if ([weakSelf.dataArray[5] boolValue] == YES) {
            [weakSelf getEthernetInterfacesData];
        } else if ([weakSelf.dataArray[6] boolValue] == YES) {
            [weakSelf getHealthData];
        } else {
            [weakSelf getFinsih];
        }
    }
}


- (void)getEthernetInterfacesData {
    //网络信息
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]] && Members.count > 0) {
            
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        
                        NSMutableString *tempstr1 = [NSMutableString new];
                        [tempstr1 appendFormat:@"<div><h3>%@</h3>",LocalString(@"reportnetwork")];
                        [tempstr1 appendFormat:@"<table>"];
                        //ipv4
                        
                        NSArray *IPv4Addresses = result14[@"IPv4Addresses"];
                        NSDictionary *IPv4Addresse = nil;
                        if (IPv4Addresses.isSureArray && IPv4Addresses.count > 0) {
                            IPv4Addresse = [IPv4Addresses firstObject];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",@"IPv4",@""];
                            
                            NSString *AddressOriginState = @"";
                            NSString *AddressOrigin = IPv4Addresse[@"AddressOrigin"];
                            if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"Static"]) {
                                AddressOriginState = LocalString(@"localno");
                            } else if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"DHCP"]) {
                                AddressOriginState = LocalString(@"localyes");
                            } else {
                                AddressOriginState = LocalString(@"localno");
                            }
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_dhcp"),AddressOriginState];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_ip_address"),IPv4Addresse[@"Address"]];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_subnet_mask"),IPv4Addresse[@"SubnetMask"]];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_gateway"),IPv4Addresse[@"Gateway"]];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_mac"),result14[@"PermanentMACAddress"]];
                            
                        }
                        [tempstr1 appendString:@"</table>"];
                        
                        //ipv6
                        [tempstr1 appendFormat:@"<table>"];
                        NSArray *IPv6Addresses = result14[@"IPv6Addresses"];
                        NSDictionary *IPv6Addresse = nil;
                        if (IPv6Addresses.isSureArray && IPv6Addresses.count > 0) {
                            IPv6Addresse = [IPv6Addresses firstObject];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",@"IPv6",@""];
                            
                            NSString *AddressOriginState = @"";
                            NSString *AddressOrigin = IPv6Addresse[@"AddressOrigin"];
                            if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"Static"]) {
                                AddressOriginState = LocalString(@"localno");
                            } else if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"DHCP"]) {
                                AddressOriginState = LocalString(@"localyes");
                            } else {
                                AddressOriginState = LocalString(@"localno");
                            }
                            
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_dhcp"),AddressOriginState];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_ip_address"),IPv6Addresse[@"Address"]];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_prefix_len"),IPv6Addresse[@"PrefixLength"]];
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_gateway"),result14[@"IPv6DefaultGateway"]];
                            
                            NSDictionary *IPv6Addresse2 = nil;
                            if (IPv6Addresses.isSureArray && IPv6Addresses.count > 1) {
                                IPv6Addresse2 = [IPv6Addresses lastObject];
                            }
                            NSString *Address = IPv6Addresse2[@"Address"];
                            if (Address.isSureString) {
                                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"ns_network_label_link_local_address"),Address];
                            }
                            
                        }
                        
                        [tempstr1 appendString:@"</table>"];
                        
                        [tempstr1 appendString:@"</div>"];
//                        [weakSelf.collectStatusArray replaceObjectAtIndex:5 withObject:@(YES)];
                        [weakSelf.dataResultArray addObject:tempstr1];
//                        [weakSelf getHealthData];
                        if ([weakSelf.dataArray[6] boolValue] == YES) {
                            [weakSelf getHealthData];
                        } else {
                            [weakSelf getFinsih];
                        }
                        
                    } failure:^(NSError *error) {
//                        [weakSelf.collectStatusArray replaceObjectAtIndex:5 withObject:@(YES)];
                        [weakSelf getFinsih];
                    }];
                    break;
                } else {
                    [weakSelf.dataResultArray addObject:@""];
//                    [weakSelf getHealthData];
                    if ([weakSelf.dataArray[6] boolValue] == YES) {
                        [weakSelf getHealthData];
                    } else {
                        [weakSelf getFinsih];
                    }
                }
            }
        } else {
//            [weakSelf.collectStatusArray replaceObjectAtIndex:5 withObject:@(YES)];
            [weakSelf.dataResultArray addObject:@""];
//            [weakSelf getFinsih];
//            [weakSelf getHealthData];
            if ([weakSelf.dataArray[6] boolValue] == YES) {
                [weakSelf getHealthData];
            } else {
                [weakSelf getFinsih];
            }
        }
        
    } failure:^(NSError *error) {
//        [weakSelf.collectStatusArray replaceObjectAtIndex:5 withObject:@(YES)];
        [weakSelf getFinsih];
    }];
    
}


- (void)getHealthData {
    //实时状态
    __block NSInteger tempCount = 0;
    NSArray *healthtitleArray = @[LocalString(@"healthfan"),LocalString(@"healthsupply"),LocalString(@"healthhard"),LocalString(@"healthcpu"),LocalString(@"healthmemory"),LocalString(@"healthtemp")];
    NSMutableArray *healthDataArray = [NSMutableArray new];
    [healthDataArray addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];
    NSMutableString *tempstr1 = [NSMutableString new];
    [tempstr1 appendFormat:@"<div><h3>%@</h3>",LocalString(@"devicedetaildashboar")];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/Thermal",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result15) {
        NSArray *temperatures = result15[@"Temperatures"];
        if (temperatures.isSureArray) {
            
            [tempstr1 appendFormat:@"<table>"];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"devicedetaildashboar"),@""];
            
            for (NSDictionary *object in temperatures) {
                NSString *ReadingCelsius = object[@"ReadingCelsius"];
                NSString *ReadingCelsiusName = object[@"Name"];
                if (![ReadingCelsius isKindOfClass:[NSNull class]]) {
                    if ([ReadingCelsiusName hasSuffix:@"DTS"] || [ReadingCelsiusName hasSuffix:@"Margin"]) {
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",object[@"Name"],ReadingCelsius];
                    } else {
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@°C</td></tr>",object[@"Name"],ReadingCelsius];

                    }
                }
            }
            
            [tempstr1 appendFormat:@"</table>"];
        }
        
        NSDictionary *oem = result15[@"Oem"];
        if (oem.isSureDictionary) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSDictionary *fanSummary = huawei[@"FanSummary"];
                if (fanSummary.isSureDictionary) {
                    NSDictionary *status = fanSummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [healthDataArray replaceObjectAtIndex:0 withObject:healthRollup];
                        }
                    }
                }
                
                
                NSDictionary *temperatureSummary = huawei[@"TemperatureSummary"];
                if (temperatureSummary.isSureDictionary) {
                    NSDictionary *status = temperatureSummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [healthDataArray replaceObjectAtIndex:5 withObject:healthRollup];
                        }
                    }
                }
                
            }
        }
        tempCount ++;
        tempCount ++;
        
        if (tempCount == 6) {
            
            [tempstr1 appendFormat:@"<table>"];
            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"healthstatus"),@""];
            
            for (NSInteger i = 0; i<healthDataArray.count; i++) {
                NSString *str = healthDataArray[i];
                if ([str isEqualToString:@"OK"]) {
                    str = LocalString(@"ok");
                } else if ([str isEqualToString:@"Warning"]) {
                    str = LocalString(@"warning");
                } else if ([str isEqualToString:@"Critical"]) {
                    str = LocalString(@"critical");
                }
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",healthtitleArray[i],str];
                
            }
            [tempstr1 appendFormat:@"</table>"];
            [tempstr1 appendFormat:@"</div>"];
//            [weakSelf.collectStatusArray replaceObjectAtIndex:6 withObject:@(YES)];
//            [weakSelf.dataResultArray replaceObjectAtIndex:6 withObject:tempstr1];
//            [weakSelf.dataResultArray addObject:tempstr1];
//            [weakSelf getFinsih];
        }
        
        
        [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result16) {
            
            NSDictionary *oem = result16[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    
                    NSDictionary *powerSupplySummary = huawei[@"PowerSupplySummary"];
                    if (powerSupplySummary.isSureDictionary) {
                        NSDictionary *status = powerSupplySummary[@"Status"];
                        if (status.isSureDictionary) {
                            NSString *healthRollup = status[@"HealthRollup"];
                            if (healthRollup.isSureString) {
                                [healthDataArray replaceObjectAtIndex:1 withObject:healthRollup];
                            }
                        }
                    }
                    
                    NSDictionary *driveSummary = huawei[@"DriveSummary"];
                    if (driveSummary.isSureDictionary) {
                        NSDictionary *status = driveSummary[@"Status"];
                        if (status.isSureDictionary) {
                            NSString *healthRollup = status[@"HealthRollup"];
                            if (healthRollup.isSureString) {
                                [healthDataArray replaceObjectAtIndex:2 withObject:healthRollup];
                            }
                        }
                    }
                }
            }
            
            tempCount ++;
            tempCount ++;
            
            if (tempCount == 6) {
                
                [tempstr1 appendFormat:@"<table>"];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"healthstatus"),@""];
                
                for (NSInteger i = 0; i<healthDataArray.count; i++) {
                    NSString *str = healthDataArray[i];
                    if ([str isEqualToString:@"OK"]) {
                        str = LocalString(@"ok");
                    } else if ([str isEqualToString:@"Warning"]) {
                        str = LocalString(@"warning");
                    } else if ([str isEqualToString:@"Critical"]) {
                        str = LocalString(@"critical");
                    }
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",healthtitleArray[i],str];
                    
                }
                [tempstr1 appendFormat:@"</table>"];
                [tempstr1 appendFormat:@"</div>"];

            }
            
            [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result17) {
                
                NSDictionary *processorSummary = result17[@"ProcessorSummary"];
                if (processorSummary.isSureDictionary) {
                    NSDictionary *status = processorSummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [healthDataArray replaceObjectAtIndex:3 withObject:healthRollup];
                        }
                    }
                }
                
                NSDictionary *memorySummary = result17[@"MemorySummary"];
                if (memorySummary.isSureDictionary) {
                    NSDictionary *status = memorySummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [healthDataArray replaceObjectAtIndex:4 withObject:healthRollup];
                        }
                    }
                }
                
                tempCount ++;
                tempCount ++;
                
                if (tempCount == 6) {
                    
                    [tempstr1 appendFormat:@"<table>"];
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"healthstatus"),@""];
                    
                    for (NSInteger i = 0; i<healthDataArray.count; i++) {
                        NSString *str = healthDataArray[i];
                        if ([str isEqualToString:@"OK"]) {
                            str = LocalString(@"ok");
                        } else if ([str isEqualToString:@"Warning"]) {
                            str = LocalString(@"warning");
                        } else if ([str isEqualToString:@"Critical"]) {
                            str = LocalString(@"critical");
                        }
                        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",healthtitleArray[i],str];
                        
                    }
                    [tempstr1 appendFormat:@"</table>"];
                    [tempstr1 appendFormat:@"</div>"];

                    [weakSelf.dataResultArray addObject:tempstr1];

                    
                }
                [weakSelf getFinsih];
            } failure:^(NSError *error) {
                [weakSelf getFinsih];
            }];
        } failure:^(NSError *error) {

            [weakSelf getFinsih];
        }];
        
    } failure:^(NSError *error) {
        [weakSelf getFinsih];
    }];
    
    
    
    
    
    
}


- (void)getFinsih {
    NSInteger tempnum = 0;
    for (NSNumber *valussss in self.dataArray) {
        if (valussss.boolValue == YES) {
            tempnum ++;
        }
    }
    
    
    if (self.dataResultArray.count == tempnum) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ReportShowViewController *vc = [[ReportShowViewController alloc] init];
        vc.contentStr = [self getReoprtHtmlStr];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"Selectreportitem");
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
    AddListTwoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
    cell1.row = indexPath.row;
    cell1.leftLabel.text = titleArray[indexPath.row];
    cell1.onOffSwitch.on = [self.dataArray[indexPath.row] boolValue];
    
    __weak typeof(self) weakSelf = self;
    cell1.didChangeStatusIndexBlock = ^(BOOL onOff, NSInteger row) {
        [weakSelf.dataArray replaceObjectAtIndex:row withObject:@(onOff)];
    };
    
    return cell1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSString *)getReoprtHtmlStr {
    NSString *contentStr = @"<!DOCTYPE html><html><head><title>Report</title><meta charset=\"UTF-8\"><meta name=\"content-type\" content=\"text/html; charset=utf-8\"><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" /><meta http-equiv=\"Cache-Control\" content=\"no-store\" /><meta http-equiv=\"Pragma\" content=\"no-cache\" /><meta http-equiv=\"Expires\" content=\"0\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta name=\"renderer\" content=\"webkit\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\"><style tyle=\"css\">h3 {display: inline-block;text-indent: 8px;border-left: 3px solid #25C4A4;margin-right: 8px;vertical-align: top;font-weight: 500;font-size: 16px;line-height: 1.1;color: inherit;margin-top: 2px;margin-bottom: 2px;}table {width: 100%;background: #FFFFFF;margin: 1em 0em;border: 1px solid #f7f2f7;box-shadow: none;text-align: left;color: rgba(0, 0, 0, 0.87);border-collapse: separate;border-spacing: 0px;}table tr td {border-top: 1px solid #f7f2f7;}table tr:first-child td {border-top: none;}table tr td:first-child {border-right: 1px solid #f7f2f7;width: 40%;}table td {padding: 6px;text-align: inherit;font-size: 13px;}</style></head><body>";
    NSString *endStr = @"</body></html>";
    
    NSMutableString *midStr = [NSMutableString new];
    
    for (NSInteger i = 0; i<self.dataResultArray.count; i++) {
//        if ([self.dataArray[i] boolValue] == YES) {
            [midStr appendString:self.dataResultArray[i]];
//        }
    }
    
    return [NSString stringWithFormat:@"%@%@%@",contentStr,midStr,endStr];
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

