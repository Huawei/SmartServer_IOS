//
//  HardwareInfoOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoTwoCell.h"
#import "DeviceDetailListCell.h"
#import "HardwareInfoTwoSectionHeaderView.h"

@interface HardwareInfoTwoCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger dataIndex;

@end

@implementation HardwareInfoTwoCell {
    NoDataView *noDataView;
    NSArray *leftArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBCOLOR(245, 242, 248);
        
    }
    
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataArray = [NSMutableArray new];
    leftArray = @[LocalString(@"hardware_memo_label_manufacturer"),@"型号",@"处理器ID",@"主频",@"核数/线程数",@"一级/二级/三级缓存",@"部件编码"];
    leftArray = @[LocalString(@"hardware_cpu_label_manufacturer"),LocalString(@"hardware_cpu_label_model"),LocalString(@"hardware_cpu_label_processor_id"),LocalString(@"hardware_cpu_label_speed_MHZ"),LocalString(@"hardware_cpu_label_cores_and_threads"),LocalString(@"hardware_cpu_label_L123_cache"),LocalString(@"hardware_cpu_label_part_no")];

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
    return 7;
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
    secview.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"Name"]];

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
        case 0:
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"Manufacturer"]];
            break;
        case 1:
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"Model"]];
            break;
        case 2: {
            NSDictionary *ProcessorId = dic[@"ProcessorId"];
            if (ProcessorId.isSureDictionary) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",ProcessorId[@"IdentificationRegisters"]];
            }
        }
            break;
        case 3: {
            cell.contentLabel.text = [NSString stringWithFormat:@"N/A"];
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *frequencyMHz = huawei[@"FrequencyMHz"];
                    if (frequencyMHz && ![frequencyMHz isKindOfClass:[NSNull class]]) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@ MHz",frequencyMHz];

                    }
                }
            }
        }
            break;
        case 4:
            cell.contentLabel.text = [NSString stringWithFormat:@"%@ Cores/%@ Threads",dic[@"TotalCores"],dic[@"TotalThreads"]];
            break;
        case 5: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@/%@/%@ KB",huawei[@"L1CacheKiB"],huawei[@"L2CacheKiB"],huawei[@"L3CacheKiB"]];
                }
            }
        }
            break;
        case 6: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *partnumber = huawei[@"PartNumber"];
                    if (partnumber && ![partnumber isKindOfClass:[NSNull class]]) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@",partnumber];
                    } else {
                        cell.contentLabel.text = [NSString stringWithFormat:@"N/A"];

                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    
    //cpu
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Processors",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
           
            [weakSelf.dataArray removeAllObjects];
            weakSelf.dataIndex = 0;
            if (Members.count > 0) {
                [weakSelf getDataIndexWithArray:Members];
            } else {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
                [weakSelf showNoData];
                if (weakSelf.didHardwareInfoTwoBlock) {
                    weakSelf.didHardwareInfoTwoBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                }
            }
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf showNoData];
        if (weakSelf.didHardwareInfoTwoBlock) {
            weakSelf.didHardwareInfoTwoBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
        }
    }];
    
}

- (void)getDataIndexWithArray:(NSArray *)Members {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = Members[self.dataIndex];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            [weakSelf.dataArray addObject:result14];
            if (weakSelf.dataArray.count == Members.count) {
                [weakSelf.tableView reloadData];
                if (weakSelf.didHardwareInfoTwoBlock) {
                    weakSelf.didHardwareInfoTwoBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
                }
                
                NSArray *arr111 = [weakSelf.dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary *dic1 = obj1;
                    NSDictionary *dic2 = obj2;
                    NSString *number1 = dic1[@"Name"];
                    NSString *number2 = dic2[@"Name"];
                    return [number1 compare:number2];
                }];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.dataArray addObjectsFromArray:arr111];
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf showNoData];
            } else {
                weakSelf.dataIndex ++;
                [weakSelf getDataIndexWithArray:Members];
            }
            
        } failure:^(NSError *error) {
            [weakSelf.tableView reloadData];
            if (weakSelf.didHardwareInfoTwoBlock) {
                weakSelf.didHardwareInfoTwoBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showNoData];
        }];
        
    } else {
        if (weakSelf.didHardwareInfoTwoBlock) {
            weakSelf.didHardwareInfoTwoBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
        }
        [weakSelf showNoData];
    }
}

@end
