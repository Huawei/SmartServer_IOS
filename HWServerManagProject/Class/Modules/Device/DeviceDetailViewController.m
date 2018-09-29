//
//  DeviceDetailViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "DeviceDetailListCell.h"
#import "DeviceDetailListTwoCell.h"
#import "DeviceDetailHeaderView.h"
#import "HealthMainViewController.h"
#import "DeviceLocationViewController.h"
#import "SysLogViewController.h"
#import "NetSettingViewController.h"
#import "HardwareInfoViewController.h"
#import "PowerConsumptionViewController.h"
#import "StartupSettingViewController.h"
#import "PowerSwitchMainViewController.h"
#import "CustomZXTitleView.h"
#import "RealTimeStatusMainViewController.h"
#import "LocateLampViewController.h"
#import "FirmwareViewController.h"
#import "GenerateReportViewController.h"
#import "QRCodeScanVC.h"
#import "DeviceDetailChangePopView.h"
#import "AKeyCollectViewController.h"

@interface DeviceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DeviceDetailHeaderView *headerView;
@property (strong, nonatomic) DeviceDetailChangePopView *popView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *leftArray;
@property (strong, nonatomic) NSMutableArray *dataResultArray;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSDictionary *data2;
@property (copy, nonatomic) NSString *imgProductPic;

@property (copy, nonatomic) NSString *logServices;//健康事件查询

@property (assign, nonatomic) BOOL isSupportStartMode;//是否支持设置启动模式

@end

@implementation DeviceDetailViewController

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

- (DeviceDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"DeviceDetailHeaderView" owner:nil options:nil] lastObject];
    }
    return _headerView;
}

- (DeviceDetailChangePopView *)popView {
    if (!_popView) {
        _popView = [[[NSBundle mainBundle] loadNibNamed:@"DeviceDetailChangePopView" owner:nil options:nil] lastObject];
        
        __weak typeof(self) weakSelf = self;
        _popView.didSelectDeviceBlock = ^(DeviceModel *model) {
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
            [ABNetWorking deleteWithSessionService:^{
                weakSelf.subtitleLabel.text = model.deviceName;
                weakSelf.titleLabel.text = model.otherName;
                [HWGlobalData shared].curDevice = model;
                [weakSelf refreshData];
            }];
        };
    }
    return _popView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListTwoCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListTwoCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.headerView;
        
    }
    
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *controllers = self.navigationController.viewControllers;
    UIViewController *controller = controllers[controllers.count-2];
    if ([controller isKindOfClass:[QRCodeScanVC class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:controllers];
        [array removeObjectAtIndex:controllers.count-2];
        self.navigationController.viewControllers = array;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"设备详情";
    self.view.backgroundColor = NormalApp_Line_Color;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        btn.frame = CGRectMake(0,0, 35, 44);
    } else {
        btn.frame = CGRectMake(0,0, 44, 44);
    }
    [btn setImage:[UIImage imageNamed:@"one_devicedetailnavrighticon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeDevice) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextbuttonitem;
    
    [self createNavView];
    
    self.leftArray = @[LocalString(@"productmodel"),LocalString(@"ipv4address"),LocalString(@"ipv6address"),LocalString(@"deviceaddress"),LocalString(@"healthstatus"),LocalString(@"powerstatus"),LocalString(@"productsn"),LocalString(@"assettag"),LocalString(@"bmcversion"),LocalString(@"biosversion"),LocalString(@"cpuinfo"),LocalString(@"memoryinfo")];

    [self.dataArray addObjectsFromArray:@[@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-"]];

    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.headerView.didItemBlock = ^(NSInteger itemRow) {
//        else if (itemRow == 1) {
//            SysLogViewController *vc = [SysLogViewController new];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }
        if (itemRow == 0) {
//            if (weakSelf.logServices) {
                HealthMainViewController *vc = [HealthMainViewController new];
                vc.logServices = weakSelf.logServices;
                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }

        } else if (itemRow == 1) {
            NetSettingViewController *vc = [NetSettingViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 2) {
            HardwareInfoViewController *vc = [HardwareInfoViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 3) {
            RealTimeStatusMainViewController *vc = [RealTimeStatusMainViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 4) {
            DeviceLocationViewController *vc = [DeviceLocationViewController new];
            vc.devicelocation = weakSelf.dataArray[3];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            vc.didChangeLocationBlock = ^(NSString *devicelocation) {
                weakSelf.dataArray[3] = devicelocation;
                [weakSelf.tableView reloadData];
            };
        } else if (itemRow == 5) {
            PowerConsumptionViewController *vc = [PowerConsumptionViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 6) {
            StartupSettingViewController *vc = [StartupSettingViewController new];
            vc.isSupportStartMode = weakSelf.isSupportStartMode;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 7) {
            PowerSwitchMainViewController *vc = [PowerSwitchMainViewController new];
            vc.powerStateStr = weakSelf.dataArray[5];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            vc.didControlMainCompleteBlock = ^(NSString *powerStateStr) {
                weakSelf.dataArray[5] = powerStateStr;
                weakSelf.headerView.powerStateLabel.text = powerStateStr;
                [weakSelf.tableView reloadData];
            };
        } else if (itemRow == 8) {
            LocateLampViewController *vc = [LocateLampViewController new];
//            vc.powerStateStr = weakSelf.dataArray[5];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 9) {
            FirmwareViewController *vc = [FirmwareViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 10) {
            GenerateReportViewController *vc = [GenerateReportViewController new];
            NSMutableString *tempstr = [NSMutableString new];
            [tempstr appendFormat:@"<div><h3>%@</h3><table>",LocalString(@"reportsysinfo")];
            for (NSInteger i = 0; i<weakSelf.leftArray.count; i++) {
                NSString *str1 = weakSelf.leftArray[i];
                NSString *str2 = weakSelf.dataArray[i];
                [tempstr appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",str1,str2];
            }
            [tempstr appendString:@"</table></div>"];
            vc.htmlStr1 = tempstr;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if (itemRow == 11) {
            AKeyCollectViewController *vc = [AKeyCollectViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    
    self.headerView.didToHealthBlock = ^{
        HealthMainViewController *vc = [HealthMainViewController new];
        vc.logServices = weakSelf.logServices;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.headerView.didChangeFrameBlock = ^{
        weakSelf.tableView.tableHeaderView = nil;
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    };
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    [weakSelf refreshData];
    
    [[HWGlobalData shared] getHistoryLookDevices];
    
    [[HWGlobalData shared] saveHistoryDevice:[HWGlobalData shared].curDevice];
}

- (void)createNavView {
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 100, TabHeight - 44, 200, 44)];
    CustomZXTitleView *tempTitleView = [[CustomZXTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavHeight-20)];
//    tempTitleView.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = tempTitleView;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat width = 200;
        weakSelf.titleView.frame = CGRectMake((ScreenWidth-width)/2, NavHeight - 44, width, weakSelf.titleView.height);
        weakSelf.titleView.frame = [weakSelf.view.window convertRect:weakSelf.titleView.frame toView:weakSelf.navigationItem.titleView];
        [weakSelf.navigationItem.titleView addSubview:weakSelf.titleView];
    });
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.titleView.frame.size.height - 44, 60, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [HWGlobalData shared].curDevice.otherName;
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.titleView.mas_centerX);
        make.top.equalTo(@6);
        make.height.equalTo(@18);
    }];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.titleView.frame.size.height - 44, 60, 44)];
    subtitleLabel.font = [UIFont boldSystemFontOfSize:10];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:subtitleLabel];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.text = [HWGlobalData shared].curDevice.deviceName;
    self.subtitleLabel = subtitleLabel;
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.titleView.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@10);
    }];

}

- (void)changeDevice {
    
    [self.navigationController.view addSubview:self.popView];
    self.popView.dataArray = [NSMutableArray arrayWithArray:[HWGlobalData shared].historyDeviceArray];
    for (DeviceModel *model in self.popView.dataArray) {
        if (model.timeSp == [HWGlobalData shared].curDevice.timeSp) {
            [self.popView.dataArray removeObject:model];
            break;
        }
    }
    [self.popView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    secView.backgroundColor = NormalApp_Line_Color;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 45)];
    label.text = LocalString(@"basicinfo");
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        DeviceDetailListTwoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListTwoCell"];
        cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
        cell1.titleLabel.text = self.leftArray[indexPath.row];
        cell1.contentLabel.text = self.dataArray[indexPath.row];
        if ([cell1.contentLabel.text isEqualToString:LocalString(@"ok")]) {
            cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
        } else if ([cell1.contentLabel.text isEqualToString:LocalString(@"warning")]) {
            cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
        } else {
            cell1.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
        }
        __weak typeof(self) weakSelf = self;
        cell1.didToHealthCellBlock = ^{
            HealthMainViewController *vc = [HealthMainViewController new];
            vc.logServices = weakSelf.logServices;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell1;
    } else if (indexPath.row == 5) {
        DeviceDetailListTwoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListTwoCell"];
        
        cell1.iconIMV.image = self.headerView.powerStateIMV.image;//[UIImage imageNamed:@"one_devicedetailmodelicon8"];
        cell1.titleLabel.text = self.leftArray[indexPath.row];
        cell1.contentLabel.text = self.dataArray[indexPath.row];
        cell1.didToHealthCellBlock = nil;
        return cell1;
    }
    
    DeviceDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
    cell.titleLabel.text = self.leftArray[indexPath.row];
    cell.contentLabel.text = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    DeviceModel *model = [HWGlobalData shared].curDevice;
    if (model) {
        [ABNetWorking deleteWithSessionService:^{
            [HWGlobalData shared].curDevice = model;
            [weakSelf refreshGetData];
        }];
    } else {
        [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"operationfail")];
        [weakSelf.tableView.mj_header endRefreshing];
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (void)refreshGetData {
    
    __weak typeof(self) weakSelf = self;
    
    [ABNetWorking getImageSuccess:^(NSString *imageurlstr) {
        if (imageurlstr.length > 0) {
            NSString *urlstring = [NSString stringWithFormat:@"%@%@",[HWGlobalData shared].curDevice.deviceName,imageurlstr];
            if (![urlstring hasPrefix:@"http"]) {
                urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
            }
            weakSelf.imgProductPic = urlstring;
            
            [weakSelf.headerView.picImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.imgProductPic] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
        }
    }];

    [ABNetWorking postWithUrlWithAction:@"redfish/v1/SessionService/Sessions" parameters:@{@"UserName":[HWGlobalData shared].curDevice.account,@"Password":[HWGlobalData shared].curDevice.password} success:^(NSDictionary *result1) {
        
        [HWGlobalData shared].session_id = result1[@"Id"];
        
        [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            
            NSDictionary *LogServices = result[@"LogServices"];
            if (LogServices.isSureDictionary) {
                weakSelf.logServices = LogServices[@"@odata.id"];
            }
            
            //是否支持设置启动模式
            NSDictionary *oem = result[@"Oem"];
            weakSelf.isSupportStartMode = NO;
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    
                    NSString *productVersion = huawei[@"ProductVersion"];
                    if (productVersion.isSureString && [productVersion isEqualToString:@"V5"]) {
                        NSNumber *bootModeChangeEnabled =  huawei[@"BootModeChangeEnabled"];
                        if (bootModeChangeEnabled != nil) {
                            if (![bootModeChangeEnabled isKindOfClass:[NSNull class]]) {
                                if (bootModeChangeEnabled.boolValue) {
                                    weakSelf.isSupportStartMode = YES;
                                }
                            }
                            
                        } else {
                            NSNumber *bootModeConfigOverIpmiEnabled =  huawei[@"BootModeConfigOverIpmiEnabled"];
                            if (bootModeConfigOverIpmiEnabled != nil) {
                                if (![bootModeConfigOverIpmiEnabled isKindOfClass:[NSNull class]]) {
                                    if (bootModeConfigOverIpmiEnabled.boolValue) {
                                        weakSelf.isSupportStartMode = YES;
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
            }
            
            //产品型号
            NSString *tempstr11 = result[@"Model"];
            if (![tempstr11 isKindOfClass:[NSNull class]]) {
                [weakSelf.dataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",result[@"Model"]]];
                weakSelf.headerView.nameLabel.text = [NSString stringWithFormat:@"%@",tempstr11];
            }
            
            //健康状态
            NSDictionary *Status = result[@"Status"];
            if (Status.isSureDictionary) {
                NSString *Health = Status[@"Health"];
                if (Health.isSureString) {
                    if ([Health isEqualToString:@"OK"]) {
                        [weakSelf.dataArray replaceObjectAtIndex:4 withObject:LocalString(@"ok")];
                        [weakSelf.headerView.statusBtn setImage:[UIImage imageNamed:@"one_health_icon0"] forState:UIControlStateNormal];
                    } else  if ([Health isEqualToString:@"Warning"]) {
                        [weakSelf.dataArray replaceObjectAtIndex:4 withObject:LocalString(@"warning")];
                        [weakSelf.headerView.statusBtn setImage:[UIImage imageNamed:@"one_health_icon2"] forState:UIControlStateNormal];

                    } else {
                        [weakSelf.dataArray replaceObjectAtIndex:4 withObject:LocalString(@"critical")];
                        [weakSelf.headerView.statusBtn setImage:[UIImage imageNamed:@"one_health_icon1"] forState:UIControlStateNormal];

                    }
                }
            }
            
            //上电状态
            NSString *PowerState = result[@"PowerState"];
            if (PowerState.isSureString) {
                if ([PowerState isEqualToString:@"On"]) {
                    [weakSelf.dataArray replaceObjectAtIndex:5 withObject:LocalString(@"powerstateon")];
                    weakSelf.headerView.powerStateLabel.text = LocalString(@"powerstateon");
                    weakSelf.headerView.powerStateIMV.image = [UIImage imageNamed:@"one_ic_power_on"];
                } else {
                    [weakSelf.dataArray replaceObjectAtIndex:5 withObject:LocalString(@"powerstateoff")];
                    weakSelf.headerView.powerStateLabel.text = LocalString(@"powerstateoff");
                    weakSelf.headerView.powerStateIMV.image = [UIImage imageNamed:@"one_ic_power_off"];
                }
            }
            
            NSString *SerialNumber = result[@"SerialNumber"];
            if (SerialNumber.isSureString) {
                [weakSelf.dataArray replaceObjectAtIndex:6 withObject:SerialNumber];
                if (SerialNumber.length > 0 && ![[HWGlobalData shared].curDevice.serialNumber isEqualToString:SerialNumber]) {
                    [HWGlobalData shared].curDevice.serialNumber = SerialNumber;
                    [[HWGlobalData shared] saveCurAllDevice];
                }
            }
            
            NSString *AssetTag = result[@"AssetTag"];
            if (AssetTag.isSureString) {
                [weakSelf.dataArray replaceObjectAtIndex:7 withObject:AssetTag];
            }
            
            
            NSString *BiosVersion = result[@"BiosVersion"];
            if (BiosVersion.isSureString) {
                [weakSelf.dataArray replaceObjectAtIndex:9 withObject:BiosVersion];
            }
            
            //CPU信息
            NSString *cpuStr = @"0";
            NSDictionary *ProcessorSummary = result[@"ProcessorSummary"];
            if (ProcessorSummary.isSureDictionary) {
                NSString *Count = [NSString stringWithFormat:@"%@",ProcessorSummary[@"Count"]];
                if (Count.isSureString && Count.length > 0) {
                    cpuStr = Count;
                }
            }
            NSDictionary *Processors = result[@"Processors"];
            if (Processors.isSureDictionary) {
                NSString *odata_id = Processors[@"@odata.id"];
                if (odata_id.isSureString && odata_id.length > 0) {
                    
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result13) {
                        
                        NSArray *Members = result13[@"Members"];
                        if (Members && [Members isKindOfClass:[NSArray class]]) {
                            
                            for (NSDictionary *dic in Members) {
                                NSString *odata_id = dic[@"@odata.id"];
                                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                                    
                                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                                        
                                        
                                        NSString *Model = result14[@"Model"];
                                        if (Model.isSureString && Model.length > 0) {
                                            
                                            [weakSelf.dataArray replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@*%@",cpuStr,Model]];
                                        }
                                        
                                        [weakSelf.tableView reloadData];
                                        [weakSelf requestTemp2];
                                    } failure:^(NSError *error) {
                                        [weakSelf requestTemp2];
                                    }];
                                } else {
                                    [weakSelf requestTemp2];
                                }
                                
                                break;
                            }
                        }
                    } failure:^(NSError *error) {
                        [weakSelf requestTemp2];
                    }];
                } else {
                    [weakSelf requestTemp2];
                }
            } else {
                [weakSelf requestTemp2];
            }
            
            //内存信息
            
            NSDictionary *MemorySummary = result[@"MemorySummary"];
            if (MemorySummary.isSureDictionary) {
                NSString *TotalSystemMemoryGiB = MemorySummary[@"TotalSystemMemoryGiB"];
            
                    [weakSelf.dataArray replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@GB",TotalSystemMemoryGiB]];
                    
                    [weakSelf.tableView reloadData];

            }
            
            
            [weakSelf.tableView reloadData];
            
            
            
        } failure:^(NSError *error) {
            
            
            [weakSelf requestTemp2];
        }];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
   
        if (error != nil) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

- (void)requestTemp2 {
    __weak typeof(self) weakSelf = self;

    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result10) {
        
        NSDictionary *oem = result10[@"Oem"];
        if (oem && [oem isKindOfClass:[NSDictionary class]]) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSString *DeviceLocation = huawei[@"DeviceLocation"];
                if (DeviceLocation.isSureString) {
                    [weakSelf.dataArray replaceObjectAtIndex:3 withObject:DeviceLocation];
                }
                
            }
        }
        
        NSString *FirmwareVersion = result10[@"FirmwareVersion"];
        if (FirmwareVersion.isSureString) {
            [weakSelf.dataArray replaceObjectAtIndex:8 withObject:FirmwareVersion];
        }
        
        NSDictionary *EthernetInterfaces = result10[@"EthernetInterfaces"];
        if (EthernetInterfaces && [EthernetInterfaces isKindOfClass:[NSDictionary class]]) {
            
            NSString *odata_id0 = EthernetInterfaces[@"@odata.id"];
            
            [ABNetWorking getWithUrlWithAction:[odata_id0 substringFromIndex:1] parameters:nil success:^(NSDictionary *result11) {
                
                NSArray *Members = result11[@"Members"];
                if (Members && [Members isKindOfClass:[NSArray class]]) {
                                        NSDictionary *dic = Members.firstObject;
                    NSString *odata_id = dic[@"@odata.id"];
                    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                        
                        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result12) {
                            
                            NSArray *IPv4Addresses = result12[@"IPv4Addresses"];
                            for (NSDictionary *addressDic in IPv4Addresses) {
                                NSString *Address = addressDic[@"Address"];
                                if (Address && [Address isKindOfClass:[NSString class]] && Address.length > 0) {
                                    [weakSelf.dataArray replaceObjectAtIndex:1 withObject:Address];
                                }
                            }
                            
                            NSArray *IPv6Addresses = result12[@"IPv6Addresses"];
                            for (NSDictionary *addressDic in IPv6Addresses) {
                                NSString *Address = addressDic[@"Address"];
                                NSString *PrefixLength = addressDic[@"PrefixLength"];
                                if (Address && [Address isKindOfClass:[NSString class]] && Address.length > 0) {
                                    [weakSelf.dataArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@/%@",Address,PrefixLength]];
                                }
                            }
                            
                            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
                            [weakSelf.tableView.mj_header endRefreshing];
                            
                            [weakSelf.tableView reloadData];
                        } failure:^(NSError *error) {
                            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
                            [weakSelf.tableView.mj_header endRefreshing];
                        }];
                    } else {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
                        [weakSelf.tableView.mj_header endRefreshing];
                    }
                    
                    
                } else {
                    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
                    [weakSelf.tableView.mj_header endRefreshing];
                }
                
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
                [weakSelf.tableView.mj_header endRefreshing];
            }];
            
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
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
