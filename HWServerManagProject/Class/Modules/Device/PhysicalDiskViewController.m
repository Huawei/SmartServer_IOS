//
//  PhysicalDiskViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/9/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "PhysicalDiskViewController.h"
#import "DeviceDetailListCell.h"
#import "HardwareInfoTwoSectionHeaderView.h"

@interface PhysicalDiskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *leftArray;

@end

@implementation PhysicalDiskViewController {
    NoDataView *noDataView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"hardware_storage_label_disk");
    self.dataArray = [NSMutableArray new];
    self.leftArray = @[LocalString(@"drive_label_protocol"),
                       LocalString(@"drive_label_manufacturer"),
                       LocalString(@"drive_label_model"),
                       LocalString(@"drive_label_sn"),
                       LocalString(@"drive_label_revision"),
                       LocalString(@"drive_label_media"),
                       LocalString(@"drive_label_temperature"),
                       LocalString(@"drive_label_fw_status"),
                       LocalString(@"drive_label_sas0"),
                       LocalString(@"drive_label_sas1"),
                       LocalString(@"drive_label_capacity"),
                       LocalString(@"drive_label_capable_speed_gbs"),
                       LocalString(@"drive_label_negotiated_speed_gbs"),
                       LocalString(@"drive_label_power_state"),
                       LocalString(@"drive_label_hotspare_type"),
                       LocalString(@"drive_label_rebuild_state"),
                       LocalString(@"drive_label_patrol_state"),
                       LocalString(@"drive_label_indicator_led"),
                       LocalString(@"drive_label_power_on_hours")];
    
    [self showNodata];
    if (self.drives.isSureArray && self.drives.count > 0) {
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self refreshData];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftArray.count;
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
            if (health.isSureString && [health isEqualToString:@"OK"]) {
                secview.title1Label.text = LocalString(@"ok");
                secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
            } else if (health.isSureString && [health isEqualToString:@"Warning"]) {
                secview.title1Label.text = LocalString(@"warning");
                secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
            }  else if (health.isSureString && [health isEqualToString:@"Critical"]) {
                secview.title1Label.text = LocalString(@"critical");
                secview.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
            } else {
                secview.title1Label.text = @"";
            }
        } else {
            secview.title1Label.text = @"";
        }
    
        secview.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"Name"]];
    
    
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
    
    cell.titleLabel.text = self.leftArray[indexPath.row];
    cell.contentLabel.text = @"-";

    
    switch (indexPath.row) {
        case 0: {
            NSString *str = dic[@"Protocol"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 1: {
            NSString *str = dic[@"Manufacturer"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 2: {
            NSString *str = dic[@"Model"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 3: {
            NSString *str = dic[@"SerialNumber"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 4: {
            NSString *str = dic[@"Revision"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 5: {
            NSString *str = dic[@"MediaType"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 6: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *str = huawei[@"TemperatureCelsius"];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@℃",str];
                    
                }
            }
            
        }
            break;
        case 7: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *str = huawei[@"FirmwareStatus"];
                    cell.contentLabel.text = str.objectWitNoNull;
                    
                }
            }
            
        }
            break;
        case 8: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSArray *array = huawei[@"SASAddress"];
                    if (array.isSureArray && array.count > 0) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@",array[0]];
                    }
                    
                }
            }
            
        }
            break;
        case 9: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSArray *array = huawei[@"SASAddress"];
                    if (array.isSureArray && array.count > 1) {
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@",array[1]];
                    }
                    
                }
            }
        }
            break;
        case 10: {
            NSString *str = dic[@"CapacityBytes"];
            if (str.integerValue < 1024) {
                NSString *tempvalue = [NSString stringWithFormat:@"%@B",str];
                if (tempvalue.length == 1) {
                    tempvalue = @"";
                }
            } else if ((str.integerValue/1024) < 1024) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%.2fKB",str.integerValue/1024.0];
            } else if ((str.integerValue/1024/1024) < 1024) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%.2fMB",str.integerValue/1024/1024.0];
            } else if ((str.integerValue/1024/1024/1024) < 1024) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%.2fGB",str.integerValue/1024/1024/1024.0];
            } else {
                cell.contentLabel.text = [NSString stringWithFormat:@"%.2fTB",str.integerValue/1024/1024/1024/1024.0];
            }
        }
            break;
        case 11: {
            NSString *str = dic[@"CapableSpeedGbs"];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@Gbps",str];
        }
            break;
        case 12: {
            NSString *str = dic[@"NegotiatedSpeedGbs"];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@Gbps",str];
        }
            break;
        case 13: {
        }
            break;
        case 14: {
            NSString *str = dic[@"HotspareType"];
            if (str.isSureString && [str isEqualToString:@"None"]) {
                cell.contentLabel.text = LocalString(@"drive_hotspare_none");
            } else if (str.isSureString && [str isEqualToString:@"Global"]) {
                cell.contentLabel.text = LocalString(@"drive_hotspare_global");
            } else if (str.isSureString && [str isEqualToString:@"Dedicated"]) {
                cell.contentLabel.text = LocalString(@"drive_hotspare_dedicated");
            }
            
        }
            break;
        case 15: {
            
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *str = huawei[@"RebuildState"];
                    if (str.isSureString && [str isEqualToString:@"DoneOrNotRebuilt"]) {
                        cell.contentLabel.text = LocalString(@"drive_rebuild_state_done_or_not_rebuilt");
                    } else if (str.isSureString && [str isEqualToString:@"Rebuilding"]) {
                        cell.contentLabel.text = LocalString(@"drive_rebuild_state_building");
                    }
                    
                }
            }
            
        }
            break;
        case 16: {
            
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *str = huawei[@"PatrolState"];
                    if (str.isSureString && [str isEqualToString:@"DoneOrNotPatrolled"]) {
                        cell.contentLabel.text = LocalString(@"drive_patroll_state_done_or_not_patrolled");
                    } else if (str.isSureString && [str isEqualToString:@"Patrolling"]) {
                        cell.contentLabel.text = LocalString(@"drive_patroll_state_patrolling");
                    }
                    
                }
            }
            
        }
            break;
        case 17: {//定位状态
            NSString *str = dic[@"IndicatorLED"];
            if (str.isSureString && [str isEqualToString:@"Off"]) {
                cell.contentLabel.text = LocalString(@"drive_indicator_led_off");
            } else if (str.isSureString && [str isEqualToString:@"Blinking"]) {
                cell.contentLabel.text = LocalString(@"drive_indicator_led_blinking");
            }
        }
            break;
        case 18: {
            NSDictionary *oem = dic[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    NSString *str = huawei[@"HoursOfPoweredUp"];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@h",str];
                    
                }
            }
            
        }
            break;
       
        default:
            break;
    }
    
    return cell;
}


- (void)showNodata {
    if (self.dataArray.count == 0) {
        noDataView = [NoDataView createFromBundle];
        UIView *foview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 400)];
        foview.backgroundColor = [UIColor clearColor];
        [foview addSubview:noDataView];
        noDataView.center = CGPointMake(ScreenWidth/2, 200);
        self.tableView.tableFooterView = foview;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
}

- (void)refreshData {
    NSMutableArray *temparray = [NSMutableArray new];
    [self getDataWithArray:self.drives withIndex:0 withArray:temparray];
}


- (void)getDataWithArray:(NSArray *)Members withIndex:(NSInteger)index withArray:(NSMutableArray *)array {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = Members[index];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            [array addObject:result14];
            if (array.count == Members.count) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [weakSelf.dataArray removeAllObjects];
                weakSelf.dataArray = array;
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf showNodata];
            } else {
                [weakSelf getDataWithArray:Members withIndex:index+1 withArray:array];
            }
            
        } failure:^(NSError *error) {
            [weakSelf.dataArray removeAllObjects];
            weakSelf.dataArray = array;
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [weakSelf showNodata];
        }];
    } else {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf showNodata];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
        
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _tableView;
}
@end
