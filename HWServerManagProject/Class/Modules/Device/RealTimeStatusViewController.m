//
//  AddDeviceViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "RealTimeStatusViewController.h"
#import "RealTimeStatusCell.h"
//#import "DeviceDetailListCell.h"
#import "HealthMainViewController.h"

@interface RealTimeStatusViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation RealTimeStatusViewController {
    NoDataView *noDataView;
    NSArray *healthArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = NormalApp_Line_Color;
    [self createBackBtn];
    
    healthArray = @[LocalString(@"healthfan"),LocalString(@"healthsupply"),LocalString(@"healthhard"),LocalString(@"healthcpu"),LocalString(@"healthmemory"),LocalString(@"healthtemp")];
  
//    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 42);

    [self.tableView registerNib:[UINib nibWithNibName:@"RealTimeStatusCell" bundle:nil] forCellReuseIdentifier:@"RealTimeStatusCell"];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);

    [self.tableView reloadData];
    
    noDataView = [NoDataView createFromBundle];
    [self.view addSubview:noDataView];
    noDataView.center = self.tableView.center;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.didRealTimeStatusBlock) {
            weakSelf.didRealTimeStatusBlock();
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
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

- (void)setTemperatures:(NSArray *)temperatures {
    _temperatures = temperatures;
    
    [self.dataArray removeAllObjects];
    for (NSDictionary *object in temperatures) {
        NSString *ReadingCelsius = object[@"ReadingCelsius"];
        if (![ReadingCelsius isKindOfClass:[NSNull class]]) {
            [self.dataArray addObject:object];
        }
    }
    
    [self.tableView reloadData];
    
    if (self.dataArray.count == 0) {
        noDataView.hidden = NO;
    } else {
        noDataView.hidden = YES;
    }
    
    [self.tableView.mj_header endRefreshing];
}

- (void)setHealthContentArray:(NSMutableArray *)healthContentArray {
    _healthContentArray = healthContentArray;
    [self.tableView reloadData];
    
    if (healthContentArray.count == 0) {
        noDataView.hidden = NO;
    } else {
        noDataView.hidden = YES;
    }
    
    [self.tableView.mj_header endRefreshing];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }

    return self.healthContentArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
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
    RealTimeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RealTimeStatusCell"];
    if (self.dataArray.count>0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"Name"]];
        if ([cell.titleLabel.text hasSuffix:@"DTS"] || [cell.titleLabel.text hasSuffix:@"Margin"]) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"ReadingCelsius"]];
        } else {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@°C",dic[@"ReadingCelsius"]];

        }
        cell.iconIMV.image = [UIImage imageNamed:@"one_temperatures_icon"];

    } else {
        cell.titleLabel.text = healthArray[indexPath.row];
        NSString *str = self.healthContentArray[indexPath.row];
        if ([str isEqualToString:@"OK"]) {
            cell.contentLabel.text = LocalString(@"ok");
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
        } else if ([str isEqualToString:@"Warning"]) {
            cell.contentLabel.text = LocalString(@"warning");
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
        } else if ([str isEqualToString:@"Critical"]) {
            cell.contentLabel.text = LocalString(@"critical");
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
        } else {
            cell.contentLabel.text = @"-";
            cell.iconIMV.image = nil;

        }
        
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count>0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSDictionary *status = dic[@"Status"];
        if (status && [status isKindOfClass:[NSDictionary class]]) {
            NSString *health = status[@"Health"];
            if (health && [health isKindOfClass:[NSString class]] && [health isEqualToString:@"OK"]) {
            } else {
                HealthMainViewController *vc = [HealthMainViewController new];
                [self.parentViewController.navigationController pushViewController:vc animated:YES];

            }
        }
    } else {
        NSString *str = self.healthContentArray[indexPath.row];
        if ([str isEqualToString:@"OK"]) {
        } else if ([str isEqualToString:@"Warning"]) {
            HealthMainViewController *vc = [HealthMainViewController new];
            [self.parentViewController.navigationController pushViewController:vc animated:YES];
        } else if ([str isEqualToString:@"Critical"]) {
            HealthMainViewController *vc = [HealthMainViewController new];
            [self.parentViewController.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
