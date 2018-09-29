//
//  SysLogViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "SysLogViewController.h"
#import "SysLogEventsCell.h"
#import "SysLogListFilterTopView.h"
#import "SysLogModel.h"

@interface SysLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SysLogListFilterTopView *topView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *eventSubject;
@property (copy, nonatomic) NSString *odata_id;
@property (copy, nonatomic) NSString *clearLogTarget;

@property (copy, nonatomic) NSString *level;
@property (copy, nonatomic) NSString *subject;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *time;
@property (assign, nonatomic) NSInteger offset;

@end

@implementation SysLogViewController {
    NoDataView *noDataView;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)eventSubject {
    if (!_eventSubject) {
        _eventSubject = [NSMutableArray new];
    }
    return _eventSubject;
}

- (SysLogListFilterTopView *)topView {
    if(!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"SysLogListFilterTopView" owner:nil options:nil] lastObject];
        _topView.frame = CGRectMake(0, 0, ScreenWidth, 56);
    }
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        //91
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, ScreenWidth, ScreenHeight - NavHeight - 56) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 168;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"SysLogEventsCell" bundle:nil] forCellReuseIdentifier:@"SysLogEventsCell"];

        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = HEXCOLOR(0xf1f1f1);
        
    }
    
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"devicedetaillog");
    [self.view addSubview:self.topView];
    self.level = @"";
    self.subject = @"";
    self.keyword = @"";
    self.time = @"";
    
    noDataView = [NoDataView createFromBundle];
    [self.tableView addSubview:noDataView];
    noDataView.center = CGPointMake(ScreenWidth/2, self.tableView.bounds.size.height/2 - 100);

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        btn.frame = CGRectMake(0,0, 35, 44);
    } else {
        btn.frame = CGRectMake(0,0, 44, 44);
    }
    [btn setImage:[UIImage imageNamed:@"one_celldeleteicon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearLogAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextbuttonitem;
    
    [self.tableView reloadData];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(moreGetData)];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [weakSelf refreshData];
    
    
    self.topView.didSelectSysTypeBlock = ^(NSInteger tabindex, NSString *value) {
       
        if (tabindex == 0) {
            NSString *temp1 = LocalString(@"system_log_select_level_critical");
            NSString *temp2 = LocalString(@"system_log_select_level_warning");
            NSString *temp3 = LocalString(@"system_log_select_level_ok");
            if ([value isEqualToString:temp1]) {
                weakSelf.level = [NSString stringWithFormat:@"level eq ‘%@‘",@"Critical"];
            } else if ([value isEqualToString:temp2]) {
                weakSelf.level = [NSString stringWithFormat:@"level eq ‘%@‘",@"Warning"];
            } else if ([value isEqualToString:temp3]) {
                weakSelf.level = [NSString stringWithFormat:@"level eq ‘%@‘",@"OK"];
            } else {
                weakSelf.level = @"";
            }

        } else if (tabindex == 1) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)value;
                weakSelf.subject = [NSString stringWithFormat:@"subject eq ‘%@‘",dic[@"Id"]];
            } else {
                weakSelf.subject = @"";
            }
        } else if (tabindex == 2) {
            NSString *temp1 = LocalString(@"system_log_select_create_date_today");
            NSString *temp2 = LocalString(@"system_log_select_create_date_seven_days");
            NSString *temp3 = LocalString(@"system_log_select_create_date_one_month");
            NSString *temp4 = LocalString(@"system_log_select_create_date_range");
            if ([value isEqualToString:temp1]) {
                NSDate *startDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *sDateString = [dateFormatter stringFromDate:startDate];
                
                weakSelf.time = [NSString stringWithFormat:@"time le ‘%@’ and time ge ‘%@’",sDateString,sDateString];
            } else if ([value isEqualToString:temp2]) {
                NSDate *startDate = [NSDate date];
                NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*7];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *sDateString = [dateFormatter stringFromDate:startDate];
                NSString *eDateString = [dateFormatter stringFromDate:endDate];

                weakSelf.time = [NSString stringWithFormat:@"time le ‘%@’ and time ge ‘%@’",sDateString,eDateString];

            } else if ([value isEqualToString:temp3]) {
                NSDate *startDate = [NSDate date];
                NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *sDateString = [dateFormatter stringFromDate:startDate];
                NSString *eDateString = [dateFormatter stringFromDate:endDate];
                
                weakSelf.time = [NSString stringWithFormat:@"time le ‘%@’ and time ge ‘%@’",sDateString,eDateString];
            }  else if ([value isEqualToString:temp4]) {

            } else {
                weakSelf.level = @"";
            }

        } else if (tabindex == 3) {
            if (value.length > 0) {
                weakSelf.keyword = [NSString stringWithFormat:@"level eq ‘%@‘",value];
            } else {
                weakSelf.keyword = @"";
            }
        }
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [weakSelf refreshData];
    };
    self.topView.didSelectSysTypeTimeBlock = ^(NSString *stime, NSString *etime) {
        weakSelf.time = [NSString stringWithFormat:@"time le ‘%@’ and time ge ‘%@’",stime,etime];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [weakSelf refreshData];
    };
}

- (void)refreshData {
    self.offset = 0;
    __weak typeof(self) weakSelf = self;
    
    if (self.odata_id) {
        NSString *uri = [NSString stringWithFormat:@"%@/EntrySet?$filter=offset eq %ld and length 20",[self.odata_id substringFromIndex:1],self.offset];
        NSMutableString *uristring = [NSMutableString stringWithFormat:@"%@",uri];
        if (self.level.length > 0) {
            [uristring appendFormat:@" and %@",self.level];
        }
        if (self.subject.length > 0) {
            [uristring appendFormat:@" and %@",self.subject];
        }
        if (self.keyword.length > 0) {
            [uristring appendFormat:@" and %@",self.keyword];
        }
        if (self.time.length > 0) {
            [uristring appendFormat:@" and %@",self.time];
        }
        NSString *tempurl = @"";
        if (@available(iOS 9.0, *)) {
            NSString *charactersToEscape = @" ";
            NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
            tempurl = [uristring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        } else {
            tempurl = [uristring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        [ABNetWorking getWithUrlWithAction:tempurl parameters:nil success:^(NSDictionary *result11) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer resetNoMoreData];
            if (weakSelf.offset == 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *entryList = result11[@"EntryList"];
            NSNumber *count = result11[@"Count"];
            if (entryList.isSureArray) {
                for (NSDictionary *dic in entryList) {
                    [weakSelf.dataArray addObject:[SysLogModel mj_objectWithKeyValues:dic]];
                }
            }
            
            if (count) {
                if (count.integerValue == weakSelf.dataArray.count) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (weakSelf.dataArray.count == 0) {
                noDataView.hidden = NO;
            } else {
                noDataView.hidden = YES;
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            if (weakSelf.offset == 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            for (NSInteger i = 0; i < 20; i++) {
                SysLogModel *model = [SysLogModel new];
                model.Id = @"22";
                model.EventId = @"Disk5";
                model.Created = @"2017-05-09T05:00:41+00:00";
                model.Message = @"Warning";
                model.EventId = @"0x02000007";
                model.Status = @"Deasserted";
                model.Suggest = @"FRU Hot Swap: Transition to M6, FRU 0 deactivation in progress";
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];

            if (weakSelf.dataArray.count == 0) {
                noDataView.hidden = NO;
            } else {
                noDataView.hidden = YES;
            }
        }];
        
        return;
    }
    
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/LogServices",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result15) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        NSArray *Members = result15[@"Members"];
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id.isSureString && odata_id.length > 0) {
                    
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result15) {
                        NSDictionary *oem = result15[@"Oem"];
                        if (oem.isSureDictionary) {
                            NSDictionary *huawei = oem[@"Huawei"];
                            if (huawei.isSureDictionary) {
                                NSArray *eventSubject = huawei[@"EventSubject"];
                                for (NSDictionary *dic in eventSubject) {
                                    [weakSelf.eventSubject addObject:dic];
                                }
                                weakSelf.topView.eventSubject = weakSelf.eventSubject;
                            }
                        }
                        NSDictionary *actions = result15[@"Actions"];
                        if (actions.isSureDictionary) {
                            NSDictionary *clearlog = actions[@"#LogService.ClearLog"];
                            if (clearlog.isSureDictionary) {
                                NSString *target = clearlog[@"target"];
                                if (target.isSureString) {
                                    weakSelf.clearLogTarget = target;
                                }
                            }
                        }

                        
                    } failure:^(NSError *error) {
                    }];
                    
                    weakSelf.odata_id = odata_id;
                    [weakSelf refreshData];
                    break;
                }
            }
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
    
    
}

- (void)moreGetData {
    self.offset = self.dataArray.count;
    __weak typeof(self) weakSelf = self;
    
    
    if (self.odata_id) {
        NSString *uri = [NSString stringWithFormat:@"%@/EntrySet?$filter=offset eq %ld and length 20",[self.odata_id substringFromIndex:1],self.offset];
        NSMutableString *uristring = [NSMutableString stringWithFormat:@"%@",uri];
        if (self.level.length > 0) {
            [uristring appendFormat:@" and %@",self.level];
        }
        if (self.subject.length > 0) {
            [uristring appendFormat:@" and %@",self.subject];
        }
        if (self.keyword.length > 0) {
            [uristring appendFormat:@" and %@",self.keyword];
        }
        if (self.time.length > 0) {
            [uristring appendFormat:@" and %@",self.time];
        }
        
        [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"%@/EntrySet",[self.odata_id substringFromIndex:1]] parameters:nil success:^(NSDictionary *result15) {
            [weakSelf.tableView.mj_footer endRefreshing];
           
            NSDictionary *oem = result15[@"Oem"];
            if (oem.isSureDictionary) {
                NSDictionary *huawei = oem[@"Huawei"];
                if (huawei.isSureDictionary) {
                    [weakSelf.dataArray removeAllObjects];
                    NSArray *eventSubject = huawei[@"EventSubject"];
                    for (NSDictionary *dic in eventSubject) {
                        [weakSelf.eventSubject addObject:dic];
                    }
                    weakSelf.topView.eventSubject = weakSelf.eventSubject;
                }
            }
            
        } failure:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];

            if (weakSelf.offset == 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            for (NSInteger i = 0; i < 20; i++) {
                SysLogModel *model = [SysLogModel new];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            
        }];
    } else {
        [weakSelf.tableView.mj_footer endRefreshing];

    }
}

- (void)clearLogAction {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"system_log_prompt_clear") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.clearLogTarget) {
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [ABNetWorking postWithUrlWithAction:[weakSelf.clearLogTarget substringFromIndex:1] parameters:@{} success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf refreshData];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

            }];
        }
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SysLogEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysLogEventsCell"];
    cell.sysLogModel = self.dataArray[indexPath.row];
    
    cell.didShowAllBlock = ^(BOOL isShowAll) {
        [tableView reloadData];
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.topView endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

