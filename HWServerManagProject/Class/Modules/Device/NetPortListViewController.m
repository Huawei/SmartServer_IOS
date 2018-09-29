//
//  NetPortListViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/21.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetPortListViewController.h"
#import "HardwareINetPortCell.h"

@interface NetPortListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation NetPortListViewController  {
    NoDataView *noDataView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//        _tableView.separatorColor = RGBCOLOR(220, 226, 236);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"HardwareINetPortCell" bundle:nil] forCellReuseIdentifier:@"HardwareINetPortCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBCOLOR(245, 242, 248);
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"netportlisttitle");
    self.dataArray = [NSMutableArray new];
    
    [self showNodata];
    
    

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [weakSelf refreshData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HardwareINetPortCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HardwareINetPortCell"];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.data = dic;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {

    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result15) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataArray removeAllObjects];
        NSArray *Members = result15[@"Members"];
        if (Members && [Members isKindOfClass:[NSArray class]] && Members.count > 0) {
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        
                        [weakSelf.dataArray addObject:result14];
                        
                        if (weakSelf.dataArray.count == Members.count) {
                            for (id object in weakSelf.dataArray) {
                                if ([object isKindOfClass:[NSString class]]) {
                                    [weakSelf.dataArray removeObject:object];
                                }
                            }
                            [weakSelf showNodata];
                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

                            NSArray *arr111 = [weakSelf.dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                NSDictionary *dic1 = obj1;
                                NSDictionary *dic2 = obj2;
                                NSNumber *number1 = dic1[@"PhysicalPortNumber"];
                                NSNumber *number2 = dic2[@"PhysicalPortNumber"];
                                if (number1.integerValue > number2.integerValue) {
                                    return NSOrderedDescending;
                                } else {
                                    return NSOrderedAscending;
                                }
                            }];
                            [weakSelf.dataArray removeAllObjects];
                            [weakSelf.dataArray addObjectsFromArray:arr111];
                            
                            [weakSelf.tableView reloadData];
                        }
                    } failure:^(NSError *error) {
                        [weakSelf.dataArray addObject:@""];
                        if (weakSelf.dataArray.count == Members.count) {
                            for (id object in weakSelf.dataArray) {
                                if ([object isKindOfClass:[NSString class]]) {
                                    [weakSelf.dataArray removeObject:object];
                                }
                            }
                            [weakSelf showNodata];
                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

                            [weakSelf.tableView reloadData];
                        }
                        
                    }];
                } else {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                }
            }

        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showNodata];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showNodata];
    }];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
