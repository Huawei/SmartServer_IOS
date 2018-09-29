//
//  HealthEventsViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HealthEventsViewController.h"
#import "HealthEventsCell.h"
#import "HealthEventsOneCell.h"

@interface HealthEventsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HealthEventsViewController {
    NoDataView *noDataView;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 168;
//        _tableView.rowHeight = 168;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"HealthEventsCell" bundle:nil] forCellReuseIdentifier:@"HealthEventsCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HealthEventsOneCell" bundle:nil] forCellReuseIdentifier:@"HealthEventsOneCell"];
        
        UIView *tempheader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
        tempheader.backgroundColor = NormalApp_BackgroundColor;
        _tableView.tableHeaderView = tempheader;
        _tableView.tableFooterView = [UIView new];
//        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundColor = NormalApp_BackgroundColor;

    }
    
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"healthevent");
    
    [self.tableView reloadData];
    
    noDataView = [NoDataView createFromBundle];
    [self.tableView addSubview:noDataView];
    noDataView.center = CGPointMake(ScreenWidth/2, self.tableView.bounds.size.height/2 - 100);
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.didRefreshBlock) {
            weakSelf.didRefreshBlock();
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
    
    if (dataArray.count == 0) {
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

    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *resolution = dic[@"Resolution"];
    if (resolution) {
        HealthEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEventsCell"];
        NSString *eventSubject = dic[@"EventSubject"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",eventSubject];
        NSString *timestr = [NSString stringWithFormat:@"%@",dic[@"Created"]];
        timestr = [timestr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        if (timestr.length > 19) {
            cell.timeLabel.text = [timestr substringToIndex:19];
        } else {
            cell.timeLabel.text = timestr;
        }
        cell.codeLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventcode"),dic[@"EventId"]];
        cell.desLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventdescription"),dic[@"Message"]];
        cell.resolutionLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventhandsug"),dic[@"Resolution"]];
        
        NSString *severity = dic[@"Severity"];
        if (severity.isSureString && [severity isEqualToString:@"OK"]) {
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
        } else if (severity.isSureString && [severity isEqualToString:@"Warning"]) {
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
        } else if (severity.isSureString && [severity isEqualToString:@"Critical"]) {
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
        }
        
        return cell;
    } else {
        HealthEventsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEventsOneCell"];
        NSString *eventSubject = dic[@"EventSubject"];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",eventSubject];

        NSString *timestr = [NSString stringWithFormat:@"%@",dic[@"Created"]];
        timestr = [timestr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        if (timestr.length > 19) {
            cell.timeLabel.text = [timestr substringToIndex:19];
        } else {
            cell.timeLabel.text = timestr;
        }
        
        cell.codeLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventcode"),dic[@"EventId"]];
        cell.desLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventdescription"),dic[@"Message"]];
        
        NSString *severity = dic[@"Severity"];
        if (severity.isSureString && [severity isEqualToString:@"OK"]) {
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
        } else if (severity.isSureString && [severity isEqualToString:@"Warning"]) {
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
        } else if (severity.isSureString && [severity isEqualToString:@"Critical"]) {
            cell.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
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
