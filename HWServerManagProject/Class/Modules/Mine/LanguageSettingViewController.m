//
//  LanguageSettingViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/14.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "LanguageSettingViewController.h"
#import "StartupSettingOneSubCell.h"

@interface LanguageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;

@end

@implementation LanguageSettingViewController {
    NSInteger didSelectIndex;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = NormalApp_Line_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"StartupSettingOneSubCell" bundle:nil] forCellReuseIdentifier:@"StartupSettingOneSubCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"duoyuyan");
    
    NSString *locallanguage = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
    if (locallanguage == nil) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage hasPrefix:@"zh-Hans"]) {
            didSelectIndex = 0;
        } else {
            didSelectIndex = 1;
        }
    } else {
        if ([locallanguage isEqualToString:@"zh-Hans"]) {
            didSelectIndex = 0;
        } else {
            didSelectIndex = 1;
        }
    }
    
    [self.tableView reloadData];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    footerView.backgroundColor = [UIColor clearColor];
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"submit") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submitBtn];
    self.tableView.tableFooterView = footerView;
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)submitAction {
    if (didSelectIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.submitBtn setTitle:LocalString(@"submit") forState:UIControlStateNormal];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguagesNoti" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"selectlanguage");
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StartupSettingOneSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartupSettingOneSubCell"];
    if (didSelectIndex == indexPath.row) {
        cell.isChecked = YES;
    } else {
        cell.isChecked = NO;
    }
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"中文";
    } else {
        cell.titleLabel.text = @"English";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    didSelectIndex = indexPath.row;
    [tableView reloadData];
    
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
