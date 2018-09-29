//
//  PowerSwitchMainOneCell.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/17.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "PowerSwitchMainOneCell.h"
#import "StartupSettingOneSubCell.h"
#import "AddListTwoCell.h"

@interface PowerSwitchMainOneCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;

@end

@implementation PowerSwitchMainOneCell {
    NSInteger didSelectIndex;
    UILabel *alertLabel;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    didSelectIndex = -1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 36;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StartupSettingOneSubCell" bundle:nil] forCellReuseIdentifier:@"StartupSettingOneSubCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
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
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, ScreenWidth-24, 40)];
    [footerView addSubview:alertLabel];
    alertLabel.text = LocalString(@"didongmoshialert3");
    alertLabel.font = [UIFont systemFontOfSize:13];
    alertLabel.textColor = RGBCOLOR(39, 177, 149);;
    alertLabel.numberOfLines = 0;
    [alertLabel sizeToFit];
    self.submitBtn.frame = CGRectMake(12, alertLabel.bottom + 10, ScreenWidth - 24, 40);
    
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
}


- (void)submitAction {
    
    if (didSelectIndex < 0) {
        return;
    }
    NSString *ResetType = @"";
    switch (didSelectIndex) {
        case 0:
            ResetType = @"On";
            break;
        case 1:
            ResetType = @"GracefulShutdown";
            break;
        case 2:
            ResetType = @"ForceOff";
            break;
        case 3:
            ResetType = @"ForceRestart";
            break;
        case 4:
            ResetType = @"ForcePowerCycle";
            break;
        case 5:
            ResetType = @"Nmi";
            break;
        default:
            break;
    }
    if (ResetType.length == 0) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking postWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Actions/ComputerSystem.Reset",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"ResetType":ResetType} success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        BLLog(@"%@",result);
        
        [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    secView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 45)];
    label.text = LocalString(@"devicedetailcontrol");
    label.textColor = HEXCOLOR(0x333333);
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 115, 0, 100, 35)];
    label2.text = self.powerStateStr;
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = NormalApp_TableView_Title_Style_Color;
    label2.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.top.bottom.equalTo(@0);
    }];
    
    UIImageView *iconIMV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [secView addSubview:iconIMV];
    [iconIMV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label2.mas_left).offset(-8);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    iconIMV.image = [UIImage imageNamed:self.powerStateImageName];
    
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 6) {
        StartupSettingOneSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartupSettingOneSubCell"];
        cell.isChecked = NO;
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = LocalString(@"poweron");
                break;
            case 1:
                cell.titleLabel.text = LocalString(@"gracefulpoweroff");
                break;
            case 2:
                cell.titleLabel.text = LocalString(@"forcepoweroff");
                break;
            case 3:
                cell.titleLabel.text = LocalString(@"forcedrestart");
                break;
            case 4:
                cell.titleLabel.text = LocalString(@"fircepowercycle");
                break;
            case 5:
                cell.titleLabel.text = LocalString(@"nmi");
                break;
               
            default:
                cell.titleLabel.text = @"";
                
                break;
        }
        if (didSelectIndex == indexPath.row) {
            cell.isChecked = YES;
        }
        return cell;
    } else {
        AddListTwoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
        cell1.leftLabel.text = @"屏蔽电源按钮";
        
        return cell1;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (didSelectIndex == indexPath.row) {
        didSelectIndex = -1;
    } else {
        didSelectIndex = indexPath.row;
    }
    [tableView reloadData];
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        //上电状态
        NSString *PowerState = result[@"PowerState"];
        if (PowerState.isSureString) {
            if ([PowerState isEqualToString:@"On"]) {
                weakSelf.powerStateStr = LocalString(@"powerstateon");
                weakSelf.powerStateImageName = @"one_ic_power_on";
            } else {
                weakSelf.powerStateStr = LocalString(@"powerstateoff");
                weakSelf.powerStateImageName = @"one_ic_power_off";
            }
        }
        if (weakSelf.didControlCompleteBlock) {
            weakSelf.didControlCompleteBlock(weakSelf.powerStateStr);
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}


@end
