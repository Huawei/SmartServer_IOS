//
//  FirmwareViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/1.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "FirmwareViewController.h"
#import "DeviceDetailListCell.h"

@interface FirmwareViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *submit1Btn;
@property (strong, nonatomic) UIButton *submit2Btn;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) UIView *footerAllView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation FirmwareViewController {
    NoDataView *noDataView;
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF1F1F1);
    self.title = LocalString(@"devicedetailfirmware");
    [self createBackBtn];
    self.dataDic = [NSMutableDictionary new];
   
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    self.footerAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
    noDataView = [NoDataView createFromBundle];
    [self.footerAllView addSubview:noDataView];
    noDataView.center = CGPointMake(ScreenWidth/2, 70);

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, 150)];
    footerView.backgroundColor = [UIColor clearColor];
    self.submit1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submit1Btn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
    self.submit1Btn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submit1Btn.layer.cornerRadius = 4;
    self.submit1Btn.layer.masksToBounds = YES;
    self.submit1Btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submit1Btn setTitle:LocalString(@"ibmcswitchover") forState:UIControlStateNormal];
    [self.submit1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submit1Btn];
    [self.footerAllView addSubview:footerView];
    self.tableView.tableFooterView = self.footerAllView;
    [self.submit1Btn addTarget:self action:@selector(submit1Action) forControlEvents:UIControlEventTouchUpInside];
    self.footerView = footerView;
    
    self.submit2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submit2Btn.frame = CGRectMake(12, 75, ScreenWidth - 24, 40);
    self.submit2Btn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submit2Btn.layer.cornerRadius = 4;
    self.submit2Btn.layer.masksToBounds = YES;
    self.submit2Btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submit2Btn setTitle:LocalString(@"RESTARTIBMC") forState:UIControlStateNormal];
    [self.submit2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submit2Btn];
    [self.submit2Btn addTarget:self action:@selector(submit2Action) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getData];
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
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"firmware_prompt_rollback") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        
        [ABNetWorking postWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/Actions/Oem/Huawei/Manager.RollBack",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{} success:^(NSDictionary *result) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.view makeToast:LocalString(@"operationsuccess")];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
        }];
        
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)submit2Action {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"firmware_prompt_reset") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];

        [ABNetWorking postWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/Actions/Manager.Reset",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"ResetType":@"ForceRestart"} success:^(NSDictionary *result) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.view makeToast:LocalString(@"operationsuccess")];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        }];
        
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
//    return self.dataDic.allKeys.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"devicedetailfirmware");
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
    DeviceDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];
    NSString *datakey = self.dataArray[indexPath.row];//self.dataDic.allKeys[indexPath.row];
    NSDictionary *dic = self.dataDic[datakey];
    if (!dic.isSureDictionary) {
        cell.contentLabel.text = LocalString(@"loading");
        NSString *titlestr =  [NSString stringWithFormat:@"%@",datakey];
        cell.titleLabel.text = titlestr;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [titlestr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        cell.leftWithConstraint.constant = size.width+3;
    } else {
        
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"Version"]];
        NSString *tempname = dic[@"Name"];
//        if (tempname && [tempname isEqualToString:@"ActiveBMC"]) {
//            tempname = @"Active iBMC";
//        } else if (tempname && [tempname isEqualToString:@"BackupBMC"]) {
//            tempname = @"Backup iBMC";
//        } else if (tempname && [tempname isEqualToString:@"Bios"]) {
//            tempname = @"BIOS";
//        }
        NSString *titlestr =  [NSString stringWithFormat:@"%@",tempname];
        cell.titleLabel.text = titlestr;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [titlestr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        cell.leftWithConstraint.constant = size.width+3;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:@"redfish/v1/UpdateService/FirmwareInventory" parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataDic removeAllObjects];
        NSArray *Members = result[@"Members"];
        if (Members && [Members isKindOfClass:[NSArray class]] && Members.count > 0) {
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    
                    NSArray *temparr = [odata_id componentsSeparatedByString:@"/"];
                    [weakSelf.dataDic setObject:odata_id forKey:temparr.lastObject];
                    [weakSelf.dataArray addObject:temparr.lastObject];
                    
                }
            }
            NSArray *temparr2 = [weakSelf.dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *temp1 = (NSString *)obj1;
                NSString *temp2 = (NSString *)obj2;
                
                if ([temp1 compare:temp2] == NSOrderedAscending) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;

                }
            }];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:temparr2];
            
            [weakSelf.tableView reloadData];
            
            for (NSString *odata_idkey in weakSelf.dataDic.allKeys) {
                NSString *odata_id = weakSelf.dataDic[odata_idkey];
                if (!odata_id.isSureString) {
                    odata_id = @"noodataid";
                }
                [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                    
                    NSString *Id = result14[@"Id"];
                    if (Id.isSureString) {
                        [weakSelf.dataDic setObject:result14 forKey:Id];
                    }
                    [weakSelf.tableView reloadData];
                } failure:^(NSError *error) {
                    [weakSelf.tableView reloadData];
                    
                }];
            }
            weakSelf.tableView.tableFooterView = weakSelf.footerView;
        } else {
            [weakSelf.footerAllView addSubview:weakSelf.footerView];
            weakSelf.tableView.tableFooterView = weakSelf.footerAllView;
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.footerAllView addSubview:weakSelf.footerView];
        weakSelf.tableView.tableFooterView = weakSelf.footerAllView;

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

