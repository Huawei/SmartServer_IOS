//
//  HardwareInfoOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoOneCell.h"
#import "HardwareInfoOneSubCell.h"

@interface HardwareInfoOneCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger dataIndex;
@property (copy, nonatomic) NSString *nextLink;

@end

@implementation HardwareInfoOneCell {
    NoDataView *noDataView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 125;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"HardwareInfoOneSubCell" bundle:nil] forCellReuseIdentifier:@"HardwareInfoOneSubCell"];
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
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

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

//- (void)setDataArray:(NSMutableArray *)dataArray {
//    _dataArray = dataArray;
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//    [self showNoData];
//}

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
    
    HardwareInfoOneSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HardwareInfoOneSubCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Memory",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        NSArray *Members = result[@"Members"];
        weakSelf.nextLink = result[@"Members@odata.nextLink"];
        if (weakSelf.nextLink && weakSelf.nextLink.isSureString && weakSelf.nextLink.length > 0) {
            [weakSelf.tableView.mj_footer resetNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            [weakSelf.dataArray removeAllObjects];
            
            if (Members.count > 0) {
                weakSelf.dataIndex = 0;
                [weakSelf getDataIndexWithArray:Members];
            } else {
                [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];

                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
                [weakSelf showNoData];
            }
            
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];

            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [weakSelf showNoData];
        }
        NSString *count = result[@"Members@odata.count"];
        if (weakSelf.didHardwareInfoOneBlock) {
            if (count && ![count isKindOfClass:[NSNull class]]) {
                weakSelf.didHardwareInfoOneBlock([NSString stringWithFormat:@"%@",count]);
            } else {
                weakSelf.didHardwareInfoOneBlock([NSString stringWithFormat:@"0"]);
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf showNoData];
        
        if (weakSelf.didHardwareInfoOneBlock) {
            weakSelf.didHardwareInfoOneBlock([NSString stringWithFormat:@"0"]);
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
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];

                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf showNoData];
            } else {
                weakSelf.dataIndex ++;
                [weakSelf getDataIndexWithArray:Members];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [weakSelf showNoData];
        }];
    } else {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf showNoData];
    }
}


- (void)loadMoreData {
    
    if (self.nextLink && self.nextLink.isSureString && self.nextLink.length > 0) {
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:[self.nextLink substringFromIndex:1],[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        NSArray *Members = result[@"Members"];
        weakSelf.nextLink = nil;
        weakSelf.nextLink = result[@"Members@odata.nextLink"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            if (Members.count > 0) {
                weakSelf.dataIndex = 0;
                [weakSelf getMoreDataIndexWithArray:Members];
            } else {
                
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                [weakSelf.tableView reloadData];
            }
            
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakSelf.tableView reloadData];
        }
        
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}


- (void)getMoreDataIndexWithArray:(NSArray *)Members {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = Members[self.dataIndex];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            [weakSelf.dataArray addObject:result14];
            if (self.dataIndex == Members.count-1) {
                [weakSelf.tableView reloadData];
                
                if (weakSelf.nextLink && weakSelf.nextLink.isSureString) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                } else {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            } else {
                weakSelf.dataIndex ++;
                [weakSelf getMoreDataIndexWithArray:Members];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            [weakSelf.tableView reloadData];
            if (weakSelf.nextLink && weakSelf.nextLink.isSureString) {
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    } else {
        [weakSelf.tableView reloadData];
        
        if (weakSelf.nextLink && weakSelf.nextLink.isSureString) {
            [weakSelf.tableView.mj_footer endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}
@end
