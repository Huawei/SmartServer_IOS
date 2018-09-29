//
//  PowerConsumptionViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "PowerConsumptionViewController.h"
#import "DeviceDetailListCell.h"

@interface PowerConsumptionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation PowerConsumptionViewController {
    NSArray *leftArray;
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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

    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"devicedetailmeter");

    leftArray = @[LocalString(@"statisticscollected"),LocalString(@"cureentpower"),LocalString(@"sysaveragepower"),LocalString(@"totalconsumedpower"),LocalString(@"peakpower"),LocalString(@"peakoccurred"),LocalString(@"curcpupower"),LocalString(@"curmemorypower")];
    NSArray *rightArray = @[LocalString(@"notsupported"),@"",@"",LocalString(@"notsupported"),@"",LocalString(@"notsupported"),LocalString(@"notsupported"),LocalString(@"notsupported")];
    [self.dataArray addObjectsFromArray:rightArray];
    
    [self.tableView reloadData];
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
//    footerView.backgroundColor = [UIColor clearColor];
//    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
//    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
//    self.submitBtn.layer.cornerRadius = 4;
//    self.submitBtn.layer.masksToBounds = YES;
//    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.submitBtn setTitle:@"清零并重新开始统计" forState:UIControlStateNormal];
//    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [footerView addSubview:self.submitBtn];
//    self.tableView.tableFooterView = footerView;
//    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)submitAction {
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"powerinfo");
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
    cell.titleLabel.text = leftArray[indexPath.row];
    switch (indexPath.row) {
        case 1: {
            NSString *str = self.dataArray[indexPath.row];
            if (str.length > 0) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@W",str];
            } else {
                cell.contentLabel.text = @"";
            }
        }
            
            break;
        case 2:{
            NSString *str = self.dataArray[indexPath.row];
            if (str.length > 0) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@W",str];
            } else {
                cell.contentLabel.text = @"";
            }
        }
            break;
        case 4:{
            NSString *str = self.dataArray[indexPath.row];
            if (str.length > 0) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@W",str];
            } else {
                cell.contentLabel.text = @"";
            }
        }
            break;
        default:
            cell.contentLabel.text = self.dataArray[indexPath.row];

            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    //电源
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/Power",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *PowerControl = result[@"PowerControl"];
        if (PowerControl && [PowerControl isKindOfClass:[NSArray class]] && PowerControl.count > 0) {
            NSDictionary *PowerControlSub = PowerControl[0];
            NSString *PowerConsumedWatts = PowerControlSub[@"PowerConsumedWatts"];
            if (![PowerConsumedWatts isKindOfClass:[NSNull class]]) {
                [weakSelf.dataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",PowerConsumedWatts]];
            }
            
            NSDictionary *PowerMetrics = PowerControlSub[@"PowerMetrics"];
            if (PowerMetrics && [PowerMetrics isKindOfClass:[NSDictionary class]]) {
                NSString *AverageConsumedWatts = PowerMetrics[@"AverageConsumedWatts"];
                if (![AverageConsumedWatts isKindOfClass:[NSNull class]]) {
                    [weakSelf.dataArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",AverageConsumedWatts]];
                }
                
                NSString *MaxConsumedWatts = PowerMetrics[@"MaxConsumedWatts"];
                if (![MaxConsumedWatts isKindOfClass:[NSNull class]]) {
                    [weakSelf.dataArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@",MaxConsumedWatts]];
                }
            }
            

        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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

