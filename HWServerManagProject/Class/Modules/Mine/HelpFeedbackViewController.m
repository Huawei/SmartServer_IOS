//
//  HelpFeedbackViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HelpFeedbackViewController.h"
#import "AddListCell.h"
#import "HelpDetailViewController.h"
#import "FeedBackViewController.h"

@interface HelpFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *submitBtn;

@end

@implementation HelpFeedbackViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[LocalString(@"useappPasswordProtection"),LocalString(@"howtoadddevice"),LocalString(@"Scan1DCode"),LocalString(@"HowtoManageServers"),LocalString(@"notesevent")].mutableCopy;
    }
    return _dataArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 90) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"helpfeedback");
    self.view.backgroundColor = NormalApp_Line_Color;
    
    [self.tableView reloadData];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavHeight - 90, ScreenWidth, 90)];
    footerView.backgroundColor = [UIColor clearColor];
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"feedback") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submitBtn];
    [self.view addSubview:footerView];
    [self.submitBtn addTarget:self action:@selector(feedBackAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)feedBackAction {
    FeedBackViewController *vc = [FeedBackViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 53;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
    cell.leftLabel.text = self.dataArray[indexPath.row];
    cell.contentLabel.text = @"";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //helphow11
    HelpDetailViewController *vc = [HelpDetailViewController new];
    vc.titleStr = self.dataArray[indexPath.row];
    NSString *abc = [NSString stringWithFormat:@"helphow%ld",indexPath.row+1];
    vc.htmlStr = LocalString(abc);
    [self.navigationController pushViewController:vc animated:YES];
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
