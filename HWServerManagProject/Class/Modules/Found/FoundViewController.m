//
//  FoundViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "FoundViewController.h"
#import "DeviceListCell.h"
#import "FoundAddCell.h"
#import "AddDeviceViewController.h"
#import "DeviceDetailViewController.h"
#import "QRCodeScanVC.h"

@interface FoundViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation FoundViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - TabHeight) style:UITableViewStyleGrouped];
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceListCell" bundle:nil] forCellReuseIdentifier:@"DeviceListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"FoundAddCell" bundle:nil] forCellReuseIdentifier:@"FoundAddCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"found");
    self.view.backgroundColor = NormalApp_Line_Color;
    [self.tableView reloadData];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguagesNoti" object:nil];
}

- (void)changeLanguageAction {
    self.title = LocalString(@"found");
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 53;
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    secView.backgroundColor = [UIColor clearColor];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    secView.backgroundColor = [UIColor clearColor];
    return secView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        FoundAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoundAddCell"];
    if (indexPath.row == 0) {
        cell.iconIMV.image = [UIImage imageNamed:@"one_celladddeviceicon"];
        cell.titleLabel.text = LocalString(@"adddevice");

    } else {
        cell.iconIMV.image = [UIImage imageNamed:@"one_cellscaneviceicon"];
        cell.titleLabel.text = LocalString(@"scandevice");
    }

        return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddDeviceViewController *vc = [[AddDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        QRCodeScanVC *vc = [[QRCodeScanVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
