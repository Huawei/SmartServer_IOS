//
//  FuncDesViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/18.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "FuncDesViewController.h"
#import "HelpDetailViewController.h"
#import "AddListCell.h"

@interface FuncDesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation FuncDesViewController {
    NSString *versionStr;
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
        _tableView.bounces = NO;
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
    self.title = LocalString(@"funcoverview");
    self.view.backgroundColor = NormalApp_Line_Color;
    
    [self.tableView reloadData];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 53;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
    cell.contentLabel.text = @"";
    cell.leftLabel.text = [NSString stringWithFormat:@"v%@",versionStr];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    HelpDetailViewController *vc = [HelpDetailViewController new];
    vc.titleStr = [NSString stringWithFormat:@"v%@",versionStr];
    vc.htmlStr = LocalString(@"versiondes");
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
