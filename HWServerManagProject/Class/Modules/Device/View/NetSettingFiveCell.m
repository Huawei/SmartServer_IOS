//
//  NetSettingTwoCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingFiveCell.h"
#import "AddListOneCell.h"
#import "AddListCell.h"
#import "AddListTwoCell.h"


@interface NetSettingFiveCell()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;

@end

@implementation NetSettingFiveCell {
    NSString *area;
    NSString *timezone;
    
    NSDictionary *zoneDic;
    NSDictionary *timezoneDic;
    
    NSDictionary *timezoneHW;
    NSDictionary *zoneHW;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
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
    
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
}


- (void)setDateTimeLocalOffset:(NSString *)dateTimeLocalOffset {
    _dateTimeLocalOffset = dateTimeLocalOffset;
    
    if (!zoneHW) {
        NSData *JSONData2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LocalString(@"zoneHW") ofType:@"json"]];
        zoneHW = [NSJSONSerialization JSONObjectWithData:JSONData2 options:NSJSONReadingMutableContainers error:nil];
    }
    if (!timezoneHW) {
        NSData *JSONData1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LocalString(@"timezoneHW") ofType:@"json"]];
        timezoneHW = [NSJSONSerialization JSONObjectWithData:JSONData1 options:NSJSONReadingMutableContainers error:nil];
        
    }
    
    if ([dateTimeLocalOffset hasPrefix:@"GMT"]) {
        area = @"GMT";
        if (dateTimeLocalOffset.length > 3) {
            timezone = [dateTimeLocalOffset substringWithRange:NSMakeRange(3, dateTimeLocalOffset.length-3)];
        } else {
            timezone = nil;
        }
        zoneDic = zoneHW;
        timezoneDic = timezoneHW;
        [self.tableView reloadData];
        
    } else {
        NSArray *arr = [dateTimeLocalOffset componentsSeparatedByString:@"/"];
        if (arr.count == 2) {
            NSString *str1 = arr[0];
            area = zoneHW[str1];
            NSDictionary *dic3 = timezoneHW[str1];
            timezone = dic3[dateTimeLocalOffset];
            zoneDic = zoneHW;
            timezoneDic = timezoneHW;
            [self.tableView reloadData];
        } else if (arr.count == 1) {
            NSString *str1 = arr[0];
            area = zoneHW[str1];
            NSDictionary *dic3 = timezoneHW[str1];
            timezone = dic3[dateTimeLocalOffset];
            zoneDic = zoneHW;
            timezoneDic = timezoneHW;
            [self.tableView reloadData];
        }
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

     return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = NormalApp_BackgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5, ScreenWidth-30, 45)];
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    
    if (section == 0) {
        label.text = LocalString(@"ns_time_zone_label_select_zone");
    } else {
        label.text = LocalString(@"ns_time_zone_label_select_timezone");
    }
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = NormalApp_BackgroundColor;
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
        cell.leftLabel.text = LocalString(@"ns_time_zone_label_zone");
        cell.contentLabel.text = area;
        return cell;
    } else {
        AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
        cell.leftLabel.text = LocalString(@"ns_time_zone_label_timezone");
        cell.contentLabel.text = timezone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dateTimeLocalOffset == nil) {
        return;
    }
    if (self.didPopAreaTimeBlock) {
        if (indexPath.section == 0) {
            self.didPopAreaTimeBlock(indexPath.section,zoneDic);
        } else {
            if ([self.dateTimeLocalOffset hasPrefix:@"GMT"]) {
                    NSDictionary *dic3 = timezoneDic[@"GMT"];
                    self.didPopAreaTimeBlock(indexPath.section,dic3);
                
            } else {
                NSArray *arr = [self.dateTimeLocalOffset componentsSeparatedByString:@"/"];
                if (arr.count == 2) {
                    NSString *str1 = arr[0];
                    NSDictionary *dic3 = timezoneDic[str1];
                    self.didPopAreaTimeBlock(indexPath.section,dic3);
                }
            }
            
           

        }
    }
}

- (void)submitAction {
    
    if (!area) {
        [self.contentView makeToast:LocalString(@"ns_time_zone_msg_zone_illegal")];
        return;
    }
    if (!timezone) {
        [self.contentView makeToast:LocalString(@"ns_time_zone_msg_timezone_illegal")];
        return;
    }
   
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"DateTimeLocalOffset":self.dateTimeLocalOffset} success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        BLLog(@"%@",result);
        [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
        [weakSelf getData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        NSDictionary *userinfo = error.userInfo;
        if (userinfo) {
            NSHTTPURLResponse *response = userinfo[@"com.alamofire.serialization.response.error.response"];
            BLLog(@"==============%ld",response.statusCode);
        }
        
        
    }];
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    //时区
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSString *DateTimeLocalOffset = result[@"DateTimeLocalOffset"];
        if (DateTimeLocalOffset.isSureString) {
            weakSelf.dateTimeLocalOffset = DateTimeLocalOffset;
//            [weakSelf.tableView reloadData];
            if (weakSelf.didRefreshAreaTimeBlock) {
                weakSelf.didRefreshAreaTimeBlock(nil, DateTimeLocalOffset);
            }
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

@end
