//
//  AboutViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "AboutViewController.h"
#import "AddListCell.h"
#import "HelpDetailViewController.h"
#import "FuncDesViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation AboutViewController

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
    self.title = LocalString(@"about");
    self.view.backgroundColor = NormalApp_Line_Color;
    
    [self.tableView reloadData];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *iconimv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 30, 20, 60, 60)];
    iconimv.image = [UIImage imageNamed:@"one_app_logo"];
    iconimv.layer.cornerRadius = 4;
    iconimv.layer.masksToBounds = YES;
//    iconimv.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:iconimv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = NormalApp_TableView_Title_Style_Color;
    [headerView addSubview:label];
    
//    [[NSBundle mainBundle] localizedInfoDictionary];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *infoDictionary2 = [[NSBundle mainBundle] localizedInfoDictionary];
    NSString *app_Name = [infoDictionary2 objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    label.text = [NSString stringWithFormat:@"%@ v%@",app_Name,app_Version];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 53;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
    cell.contentLabel.text = @"";
    switch (indexPath.row) {
        case 0:
            cell.leftLabel.text = LocalString(@"funcoverview");
            break;
        case 1:
            cell.leftLabel.text = LocalString(@"versionupdate");
            break;
        case 2:
            cell.leftLabel.text = LocalString(@"rate");
            break;
        case 3:
            cell.leftLabel.text = LocalString(@"userprotocal");
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        HelpDetailViewController *vc = [HelpDetailViewController new];
        vc.titleStr = LocalString(@"userprotocal");
        vc.htmlStr = LocalString(@"useragreement");
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 0) {
        FuncDesViewController *vc = [FuncDesViewController new];
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
