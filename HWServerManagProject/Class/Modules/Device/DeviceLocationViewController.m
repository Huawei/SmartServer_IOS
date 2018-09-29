//
//  DeviceLocationViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceLocationViewController.h"
#import "AddListOneCell.h"
#import "DeviceLocationIntputCell.h"
#import "UITextView+ZWPlaceHolder.h"

@interface DeviceLocationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *submitBtn;
@property (weak, nonatomic) UITextView *curTF;

@end

@implementation DeviceLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = NormalApp_Line_Color;
    self.title = LocalString(@"devicedetaillocation");
    [self createBackBtn];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 36;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceLocationIntputCell" bundle:nil] forCellReuseIdentifier:@"DeviceLocationIntputCell"];
    
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
    [self.submitBtn setTitle:LocalString(@"complete") forState:UIControlStateNormal];
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

- (void)createBackBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        btn.frame = CGRectMake(0,0, 60, 44);
    } else {
        btn.frame = CGRectMake(0,0, 70, 44);
    }
    [btn setImage:[UIImage imageNamed:@"one_navBackicon"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:LocalString(@"back") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = nextbuttonitem;
    [nextbuttonitem setTintColor:HEXCOLOR(0xffffff)];
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkSubmitText:(NSString *)string {
    
    if (string.length > 64 || string.length == 0) {
        return NO;
    }

    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LOGINALPHANUMDeviceLocalStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        return NO;
    };
    return YES;
    
}

- (void)submitAction {
    [self.view endEditing:YES];
    if (self.curTF.text.length == 0) {
        return;
    }
    
    if (![self checkSubmitText:self.curTF.text]) {
        [self.view makeToast:LocalString(@"devicelocationdes")];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"Oem":@{@"Huawei":@{@"DeviceLocation":self.curTF.text}}} success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BLLog(@"%@",result);
        
        NSDictionary *oem = result[@"Oem"];
        if (oem && [oem isKindOfClass:[NSDictionary class]]) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSString *DeviceLocation = huawei[@"DeviceLocation"];
                if (DeviceLocation.isSureString && [DeviceLocation isEqualToString:weakSelf.curTF.text]) {
                    
                    if (weakSelf.didChangeLocationBlock) {
                        weakSelf.didChangeLocationBlock(weakSelf.curTF.text);
                        [weakSelf.view makeToast:LocalString(@"operationsuccess")];
                    }
                    
                }
                
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    secView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 45)];
    
    label.text = LocalString(@"devicelocation");
   
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceLocationIntputCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DeviceLocationIntputCell"];
    cell1.inputTV.placeholder = LocalString(@"devicelocationpla");
    if ([self.devicelocation isEqualToString:@"-"]) {
        cell1.inputTV.text = @"";
    } else {
        cell1.inputTV.text = self.devicelocation;
    }
    cell1.desLabel.text = LocalString(@"devicelocationdes");
    
    self.curTF = cell1.inputTV;
    
    return cell1;
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSDictionary *oem = result[@"Oem"];
        if (oem && [oem isKindOfClass:[NSDictionary class]]) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSString *DeviceLocation = huawei[@"DeviceLocation"];
                if (DeviceLocation.isSureString) {
                    weakSelf.devicelocation = DeviceLocation;
                }
            }
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
  
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
