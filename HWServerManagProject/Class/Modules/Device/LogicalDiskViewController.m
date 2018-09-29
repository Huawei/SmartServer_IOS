//
//  LogicalDiskViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/9/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "LogicalDiskViewController.h"
#import "DeviceDetailListCell.h"
#import "AddListCell.h"
#import "PhysicalDiskViewController.h"

@interface LogicalDiskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *leftArray;

@end

@implementation LogicalDiskViewController {
    NoDataView *noDataView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"hardware_storage_label_volumes");
    
    self.dataArray = [NSMutableArray new];
    self.leftArray = @[@"",
                       LocalString(@"logical_label_volume_name"),
                       LocalString(@"logical_label_raid_level"),
                       LocalString(@"logical_label_capacity"),
                       LocalString(@"logical_label_strip_size"),
                       LocalString(@"logical_label_sscd_caching"),
                       LocalString(@"logical_label_default_read_policy"),
                       LocalString(@"logical_label_current_read_policy"),
                       LocalString(@"logical_label_default_write_policy"),
                       LocalString(@"logical_label_current_write_policy"),
                       LocalString(@"logical_label_default_io_policy"),
                       LocalString(@"logical_label_current_io_policy"),
                       LocalString(@"logical_label_disk_cache_policy"),
                       LocalString(@"logical_label_access_policy"),
                       LocalString(@"logical_label_init_state"),
                       LocalString(@"logical_label_bgi_enabled"),
                       LocalString(@"logical_label_l2_cache"),
                       LocalString(@"logical_label_consistency_check"),
                       LocalString(@"logical_label_boot_disk"),
                       LocalString(@"hardware_storage_label_disk")];
    
    [self showNodata];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getVolumesData];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getVolumesData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSDictionary *oem = dic[@"Oem"];
    NSDictionary *huawei = oem[@"Huawei"];
    
    DeviceDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
    cell.titleLabel.text = self.leftArray[indexPath.row];
    cell.contentLabel.text = @"";
    cell.contentView.backgroundColor = HEXCOLOR(0xffffff);
    switch (indexPath.row) {
        case 0: {
            cell.contentView.backgroundColor = HEXCOLOR(0xF1F1F1);
            NSString *str = dic[@"Id"];
            cell.titleLabel.text = str.objectWitNoNull;
            NSDictionary *status = dic[@"Status"];
            if (status.isSureDictionary) {
                NSString *state = status[@"State"];
                if (state.isSureString && [state isEqualToString:@"Enabled"]) {
                    cell.contentLabel.text = LocalString(@"logical_drive_state_enabled");
                } else if (state.isSureString && [state isEqualToString:@"Offline"]) {
                    cell.contentLabel.text = LocalString(@"logical_drive_state_offline");
                } else if (state.isSureString && [state isEqualToString:@"Degraded"]) {
                    cell.contentLabel.text = LocalString(@"logical_drive_state_degraded");
                }
            }
            
        }

            break;
        case 1:{
            NSString *str = huawei[@"VolumeName"];
            cell.contentLabel.text = str.objectWitNoNull;
        }
            break;
        case 2:{
            NSString *str = huawei[@"VolumeRaidLevel"];
            cell.contentLabel.text = str.objectWitNoNull;

        }
            break;
        case 3:{
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
        case 4:{
            NSString *str = [NSString stringWithFormat:@"%@",dic[@"OptimumIOSizeBytes"]];
            cell.contentLabel.text = str.toMemoryBString;
            
        }
            break;
        case 5:{
            NSString *str = huawei[@"SSDCachingEnable"];
            if (str.integerValue == 0) {
                cell.contentLabel.text = LocalString(@"Disable");
            } else if (str.integerValue == 1) {
                cell.contentLabel.text = LocalString(@"Enable");
            }
        }
            break;
        case 6:{
            NSString *str = huawei[@"DefaultReadPolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 7:{
            NSString *str = huawei[@"CurrentReadPolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 8:{
            NSString *str = huawei[@"DefaultWritePolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 9:{
            NSString *str = huawei[@"CurrentWritePolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 10:{
            NSString *str = huawei[@"DefaultCachePolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 11:{
            NSString *str = huawei[@"CurrentCachePolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 12:{
            NSString *str = huawei[@"DriveCachePolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 13:{
            NSString *str = huawei[@"AccessPolicy"];
            cell.contentLabel.text = str.objectWitNoNull;
            
        }
            break;
        case 14:{
            NSString *str = huawei[@"InitializationMode"];
            if (str.isSureString && [str isEqualToString:@"UnInit"]) {
                cell.contentLabel.text = LocalString(@"logical_drive_im_UnInit");
            } else if (str.isSureString && [str isEqualToString:@"QuickInit"]) {
                cell.contentLabel.text = LocalString(@"logical_drive_im_QuickInit");
            } else if (str.isSureString && [str isEqualToString:@"FullInit"]) {
                cell.contentLabel.text = LocalString(@"logical_drive_im_FullInit");
            } else {
                cell.contentLabel.text = @"N/A";
            }
            
        }
            break;
            
        case 15:{
            NSString *str = huawei[@"BGIEnable"];
            if (str.integerValue == 0) {
                cell.contentLabel.text = LocalString(@"Disable");
            } else if (str.integerValue == 1) {
                cell.contentLabel.text = LocalString(@"Enable");
            }
        }
            break;
        case 16:{
            NSString *str = huawei[@"SSDCachecadeVolume"];
            if (str.integerValue == 0) {
                cell.contentLabel.text = LocalString(@"no");
            } else if (str.integerValue == 1) {
                cell.contentLabel.text = LocalString(@"yes");
            }
            
        }
            break;
        case 17:{
            NSString *str = huawei[@"ConsistencyCheck"];
            if (str.integerValue == 0) {
                cell.contentLabel.text = LocalString(@"Stopped");
            } else if (str.integerValue == 1) {
                cell.contentLabel.text = LocalString(@"Enable");
            }
            
        }
            break;
        case 18:{
            NSString *str = huawei[@"BootEnable"];
            if (str.integerValue == 0) {
                cell.contentLabel.text = LocalString(@"no");
            } else if (str.integerValue == 1) {
                cell.contentLabel.text = LocalString(@"yes");
            }
            
        }
            break;
        case 19:{
            AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
            cell.leftLabel.text = self.leftArray[indexPath.row];
            cell.contentLabel.text = @"";
            return cell;
            
        }
            break;
        default:

            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 19) {
       

        PhysicalDiskViewController *vc = [PhysicalDiskViewController new];
        
        NSDictionary *dic = self.dataArray[indexPath.section];
        NSDictionary *links = dic[@"Links"];
        if (links.isSureDictionary) {
            NSArray *drives = links[@"Drives"];
            if (drives.isSureArray) {
                vc.drives = drives;
            }
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getVolumesData {
    
    if (self.volumes_odataId.isSureString && self.volumes_odataId.length > 0) {
        
        __weak typeof(self) weakSelf = self;
        [ABNetWorking getWithUrlWithAction:[self.volumes_odataId substringFromIndex:1] parameters:nil success:^(NSDictionary *result) {
            NSArray *Members = result[@"Members"];
            if (Members && [Members isKindOfClass:[NSArray class]]) {
                
                [weakSelf.dataArray removeAllObjects];
                
                if (Members.count > 0) {
                    [weakSelf getDataWithArray:Members withIndex:0];
                } else {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.tableView reloadData];
                    [weakSelf showNodata];
                }
                
            } else {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
                [weakSelf showNodata];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showNodata];
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];

    }
}


- (void)getDataWithArray:(NSArray *)Members withIndex:(NSInteger)index{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = Members[index];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            [weakSelf.dataArray addObject:result14];
            if (weakSelf.dataArray.count == Members.count) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf showNodata];
            } else {
                [weakSelf getDataWithArray:Members withIndex:index+1];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [weakSelf showNodata];
        }];
    } else {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf showNodata];
    }
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
        [_tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
        
    }
    
    return _tableView;
}


@end
