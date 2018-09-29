//
//  DeviceSearchViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceSearchViewController.h"
#import "DeviceDetailListCell.h"
#import "DeviceDetailViewController.h"
#import "NoDataView.h"

@interface DeviceSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DeviceSearchViewController {
    NoDataView *nodataView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIApplication *application = [UIApplication sharedApplication];
    application.statusBarStyle = UIStatusBarStyleDefault;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIApplication *application = [UIApplication sharedApplication];
    application.statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView reloadData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line.backgroundColor = NormalApp_Line_Color;
        [self.view addSubview:line];

    }
    
    nodataView = [NoDataView createFromBundle];
    nodataView.titleLabel.text = LocalString(@"nosearchhisotry");
    [self.view addSubview:nodataView];
    nodataView.center = CGPointMake(ScreenWidth/2, self.tableView.center.y - 80);
    nodataView.hidden = YES;
    
}

- (NSMutableArray *)wordArray {
    if (!_wordArray) {
        _wordArray = [NSMutableArray new];
    }
    return _wordArray;
}

- (void)clearHistoryAction {
    [self.wordArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"historysearhwordkey"];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.wordArray.count > 0) {
        nodataView.hidden = YES;
    } else {
        nodataView.hidden = NO;
    }
    return self.wordArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.wordArray.count > 0) {
        return 40;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    secView.backgroundColor = [UIColor whiteColor];
    secView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 40)];
    label.text = @"最近搜索";
    label.textColor = NormalApp_nav_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"one_cellClearIcon"] forState:UIControlStateNormal];
    [secView addSubview:btn];
    btn.frame = CGRectMake(ScreenWidth - 40, 10, 20, 20);
    [btn addTarget:self action:@selector(clearHistoryAction) forControlEvents:UIControlEventTouchUpInside];
   
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
    line.backgroundColor = NormalApp_Line_Color;
    [secView addSubview:line];
    return secView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailListCell"];

    cell.titleLabel.text = self.wordArray[indexPath.row];
    cell.contentLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.didSelectWordBlock) {
            weakSelf.didSelectWordBlock(self.wordArray[indexPath.row]);
        }
    }];
    
    
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
