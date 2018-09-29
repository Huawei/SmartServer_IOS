//
//  MineViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "MineViewController.h"
#import "MineOneCell.h"
#import "MineTwoCell.h"
#import "AddDeviceViewController.h"
#import "DeviceDetailViewController.h"
#import "SafePwdViewController.h"
#import "AboutViewController.h"
#import "HelpFeedbackViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LanguageSettingViewController.h"
#import "ThemeSkinViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;


@end

@implementation MineViewController


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
//        _tableView.rowHeight = 55;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"MineOneCell" bundle:nil] forCellReuseIdentifier:@"MineOneCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MineTwoCell" bundle:nil] forCellReuseIdentifier:@"MineTwoCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"mine");
    self.view.backgroundColor = NormalApp_Line_Color;

    [self.tableView reloadData];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguagesNoti" object:nil];

}

- (void)changeLanguageAction {
    self.title = LocalString(@"mine");
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 53;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
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
    
//    if (indexPath.section == 0) {
//        MineOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineOneCell"];
//        cell.leftLabel.text = LocalString(@"eventpush");
//        return cell;
//    }
//
    MineTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTwoCell"];
    
    switch (indexPath.row) {
        case 0:
            cell.leftLabel.text = LocalString(@"securitysettings");
            cell.iconIMV.image = [UIImage imageNamed:@"one_cellsafeicon"];
            break;
        case 1:
            cell.leftLabel.text = LocalString(@"duoyuyan");
            cell.iconIMV.image = [UIImage imageNamed:@"one_cellLanguageicon"];
            break;
        case 2:
            cell.leftLabel.text = LocalString(@"ThemeSkin");
            cell.iconIMV.image = [UIImage imageNamed:@"one_cellSkinicon"];
            break;
            
        case 3:
            cell.leftLabel.text =  LocalString(@"helpfeedback");
            cell.iconIMV.image = [UIImage imageNamed:@"one_cellfeedbackicon"];
            break;
        case 4:
            cell.leftLabel.text = LocalString(@"about");
            cell.iconIMV.image = [UIImage imageNamed:@"one_cellabouticon"];
            break;
       
            
        default:
            cell.leftLabel.text = @"";
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SafePwdViewController *vc = [SafePwdViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            LanguageSettingViewController *vc = [LanguageSettingViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            ThemeSkinViewController *vc = [ThemeSkinViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            HelpFeedbackViewController *vc = [HelpFeedbackViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            AboutViewController *vc = [AboutViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
