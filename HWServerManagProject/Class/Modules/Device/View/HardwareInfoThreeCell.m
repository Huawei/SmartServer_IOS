//
//  HardwareInfoOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoThreeCell.h"
#import "HardwareInfoThreeSubCell.h"

@interface HardwareInfoThreeCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HardwareInfoThreeCell {
    NoDataView *noDataView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
//        _tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
//        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 125;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"HardwareInfoThreeSubCell" bundle:nil] forCellReuseIdentifier:@"HardwareInfoThreeSubCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBCOLOR(245, 242, 248);
        
    }
    
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataArray = [NSMutableArray new];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *temp = [UIView new];
    temp.backgroundColor = [UIColor clearColor];
    return temp;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HardwareInfoThreeSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HardwareInfoThreeSubCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
  
    //电源
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/Power",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *PowerSupplies = result[@"PowerSupplies"];
        if (PowerSupplies && [PowerSupplies isKindOfClass:[NSArray class]]) {
            
            [weakSelf.dataArray removeAllObjects];
            
            for (NSDictionary *data in PowerSupplies) {
                NSDictionary *status = data[@"Status"];
                if (status.isSureDictionary) {
                    NSString *state = status[@"State"];
                    if (state.isSureString && [state isEqualToString:@"Enabled"]) {
                        [weakSelf.dataArray addObject:data];
                    } else if (state.isSureString && [state isEqualToString:@"Disabled"]) {
                        [weakSelf.dataArray addObject:data];
                    } else if (state.isSureString && [state isEqualToString:@"Absent"]) {
                    }
                }
            }
            
            if (weakSelf.didHardwareInfoThreeBlock) {
                weakSelf.didHardwareInfoThreeBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
            }
            
           
            
            [weakSelf.tableView reloadData];
            
        }
        [weakSelf showNoData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        if (weakSelf.didHardwareInfoThreeBlock) {
            weakSelf.didHardwareInfoThreeBlock([NSString stringWithFormat:@"%ld",weakSelf.dataArray.count]);
        }
        [weakSelf showNoData];
    }];
    
    
}


@end
