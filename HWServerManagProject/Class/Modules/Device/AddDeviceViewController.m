//
//  AddDeviceViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "AddListCell.h"
#import "AddListOneCell.h"
#import "AddListOne2Cell.h"
#import "AddListTwoCell.h"

@interface AddDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *submitBtn;

@property (copy, nonatomic) NSString *connectType;//接入方式
@property (copy, nonatomic) NSString *deviceName;//IP名/主机名
@property (copy, nonatomic) NSString *port;//端口
@property (copy, nonatomic) NSString *otherName;//别名
@property (copy, nonatomic) NSString *account;//用户
@property (copy, nonatomic) NSString *password;//密码
@property (copy, nonatomic) NSString *domain;//域
@property (assign, nonatomic) BOOL isKeepPwd;//记住密码

@end

@implementation AddDeviceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = NormalApp_Line_Color;
    [self createBackBtn];
    
    
    self.connectType = LocalString(@"network");
    if (self.model) {
        self.title = LocalString(@"editdevice");
        self.otherName = self.model.otherName;
        self.deviceName = self.model.deviceName;
        self.port = self.model.port;
        self.account = self.model.account;
        self.password = self.model.password;
        self.domain = @"";
        self.isKeepPwd = self.model.isKeepPwd;

    } else {
        self.title = LocalString(@"adddevice");
        self.otherName = @"";
        self.deviceName = @"";
        self.port = @"443";
        self.account = @"";
        self.password = @"";
        self.domain = @"";
        self.isKeepPwd = NO;
    }
 

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;

    [self.tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListOneCell" bundle:nil] forCellReuseIdentifier:@"AddListOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListOne2Cell" bundle:nil] forCellReuseIdentifier:@"AddListOne2Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
    
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
    if (self.model) {
        [self.submitBtn setTitle:LocalString(@"addsubmit2") forState:UIControlStateNormal];
    } else {
        [self.submitBtn setTitle:LocalString(@"addsubmit") forState:UIControlStateNormal];

    }
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submitBtn];
    self.tableView.tableFooterView = footerView;
    [self.submitBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView reloadData];
    

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    if (section == 0) {
        label.text = @"";
    } else if (section == 1) {
        label.text = LocalString(@"deviceinfo");
    } else {
        label.text = LocalString(@"authenticationinfo");
    }
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
    secView.backgroundColor = [UIColor clearColor];
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
        cell.leftLabel.text = LocalString(@"accessmode");
        cell.contentLabel.text = self.connectType;
        cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            AddListTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
            cell.onOffSwitch.on = self.isKeepPwd;
            cell.leftLabel.text = LocalString(@"rememberpwd");
            cell.didChangeStatusBlock = ^(BOOL onOff) {
                weakSelf.isKeepPwd = onOff;
            };
            return cell;
        }
        
        AddListOneCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"AddListOneCell"];
        cell1.inputTF.secureTextEntry = NO;
        cell1.inputTF.textAlignment = NSTextAlignmentLeft;
        switch (indexPath.row) {
            case 0: {
                cell1.leftLabel.text = LocalString(@"user");
                cell1.inputTF.placeholder = LocalString(@"userplaceholder");
                cell1.inputTF.text = self.account;
                cell1.didSureInputBlock = ^(NSString *value) {
                    weakSelf.account = value;
                };
            }
                
                break;
            case 1: {
                AddListOne2Cell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"AddListOne2Cell"];
                cell2.leftLabel.text = LocalString(@"pwd");
                cell2.inputTF.placeholder = LocalString(@"pwdplaceholder");
                cell2.inputTF.text = self.password;
                if (self.model && self.model.isKeepPwd == YES) {
                    cell2.eyeBtn.hidden = YES;
                } else {
                    cell2.eyeBtn.hidden = NO;
                }
                cell2.inputTF.textAlignment = NSTextAlignmentLeft;
                cell2.didSureInputBlock = ^(NSString *value) {
                    weakSelf.password = value;
                };
                return cell2;
            }
                
                break;
                
            default:
                 cell1.leftLabel.text = @"";
                break;
        }
        return cell1;
        
    } else {
        AddListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListOneCell"];
        cell.inputTF.textAlignment = NSTextAlignmentLeft;
        switch (indexPath.row) {
            case 0: {
                cell.leftLabel.text = LocalString(@"host");
                cell.inputTF.placeholder = LocalString(@"hostplaceholder");
                cell.inputTF.text = self.deviceName;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.deviceName = value;
                };
            }
                
                break;
            case 1: {
                cell.leftLabel.text = LocalString(@"port1");
                cell.inputTF.text = self.port;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.port = value;
                };
            }
                
                break;
//            case 2: {
//                cell.leftLabel.text = @"别名";
//                
//                cell.inputTF.text = self.otherName;
//                cell.didSureInputBlock = ^(NSString *value) {
//                    weakSelf.otherName = value;
//                };
//            }
                
                break;
                
            default:
                break;
        }
        return cell;
        
    }
}

- (void)addAction {
    [self.view endEditing:YES];
    if (!self.model) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.deviceName contains [cd] %@", self.deviceName];
        
        NSArray *filterdArray = [[HWGlobalData shared].deviceDataArray filteredArrayUsingPredicate:predicate];
        if (filterdArray.count > 0) {
            [self.view makeToast:LocalString(@"localdevicehave")];
            return;
        }
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.deviceName contains [cd] %@", self.deviceName];
        
        NSArray *filterdArray = [[HWGlobalData shared].deviceDataArray filteredArrayUsingPredicate:predicate];
        if (filterdArray.count == 1) {
            if (![filterdArray containsObject:self.model]) {
                [self.view makeToast:LocalString(@"localdevicehave")];
                return;
            }
            
        } else if (filterdArray.count > 1) {
            [self.view makeToast:LocalString(@"localdevicehave")];
            return;
        }
    }
    
    
    //https://112.93.129.231/
    if (!self.deviceName || self.deviceName.length == 0) {
        [self.view makeToast:LocalString(@"ad_hostname_is_empty")];
        return;
    }
    
    if ([self isIP4:self.deviceName]||[self isIP6:self.deviceName] || [self isDomain:self.deviceName]) {
        
    } else {
        [self.view makeToast:LocalString(@"ad_hostname_is_illegal")];
        return;
    }
    
    if (!self.port || self.port.length == 0) {
        [self.view makeToast:LocalString(@"ad_port_is_empty")];
        return;
    }
    
    if (![self isPureInt:self.port]) {
        [self.view makeToast:LocalString(@"ad_port_is_illegal")];
        return;
    }
    
    if (self.port.integerValue < 0 || self.port.integerValue > 65535) {
        [self.view makeToast:LocalString(@"ad_port_is_illegal")];
        return;
    }
    
    if (!self.account || self.account.length == 0) {
        [self.view makeToast:LocalString(@"ad_username_is_empty")];
        return;
    }
    
    if (!self.password || self.password.length == 0) {
        [self.view makeToast:LocalString(@"ad_password_is_empty")];
        return;
    }
    
//    if (!self.domain || self.domain.length == 0) {
//        [self.view makeToast:@"请输入密码"];
//        return;
//    }
    
    
    
    NSDate* dat = [NSDate date];
    NSInteger a = [dat timeIntervalSince1970];
    
    DeviceModel *model = [DeviceModel new];
    model.deviceName = self.deviceName;
    model.port = self.port;
    model.connectType = self.connectType;
    model.account = self.account;
    model.password = self.password;
    model.isKeepPwd = self.isKeepPwd;
    model.domain = self.domain;
    model.otherName = self.otherName;
    model.timeSp = a;
    
    [HWGlobalData shared].curDevice = model;
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ABNetWorking addPostWithUrlWithAction:@"redfish/v1/SessionService/Sessions" parameters:@{@"UserName":[HWGlobalData shared].curDevice.account,@"Password":[HWGlobalData shared].curDevice.password} success:^(NSDictionary *result1) {
        
        [HWGlobalData shared].session_id = result1[@"Id"];
        
        [ABNetWorking addGetWithUrlWithAction:@"redfish/v1/Chassis" parameters:nil success:^(NSDictionary *result2) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSArray *members = result2[@"Members"];
            NSString *serviceitem = nil;
            if (members.isSureArray && members.count > 0) {
                NSDictionary *tempdic = members.firstObject;
                NSString *tempstring = tempdic[@"@odata.id"];
                if (tempstring.isSureString) {
                    NSArray *temparr = [tempstring componentsSeparatedByString:@"/"];
                    if (temparr.isSureArray && temparr.count > 0) {
                        serviceitem = temparr.lastObject;
                        model.curServiceItem = serviceitem;
                    }
                }
            }
            if (!serviceitem) {
                return ;
            }
            
            [ABNetWorking addGetWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSString *SerialNumber = result[@"SerialNumber"];
                if (SerialNumber.isSureString) {
                    model.serialNumber = SerialNumber;
                }
                
                NSDictionary *Oem = result[@"Oem"];
                if (Oem.isSureDictionary) {
                    NSDictionary *huawei = Oem[@"Huawei"];
                    if (huawei.isSureDictionary) {
                        NSString *ProductAlias = huawei[@"ProductAlias"];
                        if (ProductAlias.isSureString) {
                            model.otherName = ProductAlias;
                        }
                        
                    }
                }
                //产品型号
                NSString *tempstr11 = result[@"Model"];
                if (![tempstr11 isKindOfClass:[NSNull class]]) {
                    model.otherName = tempstr11;
                }
                
                if (model.otherName.length == 0) {
                    model.otherName = LocalString(@"device");
                }
                
                if (weakSelf.model) {
                    weakSelf.model.curServiceItem = serviceitem;
                    weakSelf.model.deviceName = model.deviceName;
                    weakSelf.model.otherName = model.otherName;
                    weakSelf.model.port = model.port;
                    weakSelf.model.account = model.account;
                    weakSelf.model.password = model.password;
                    weakSelf.model.isKeepPwd = model.isKeepPwd;
                    if (model.isKeepPwd == NO) {
                        weakSelf.model.password = @"";
                        model.password = @"";
                    }
                    [[HWGlobalData shared] changeDevice:weakSelf.model];
                    
                    
                } else {
                    if (model.isKeepPwd == NO) {
                        model.password = @"";
                    }
                    [[HWGlobalData shared] saveDevice:model];
                    
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (model.otherName.length == 0) {
                    model.otherName = LocalString(@"device");
                }
                
                if (weakSelf.model) {
                    weakSelf.model.curServiceItem = model.curServiceItem;
                    weakSelf.model.deviceName = model.deviceName;
                    weakSelf.model.otherName = model.otherName;
                    weakSelf.model.port = model.port;
                    weakSelf.model.account = model.account;
                    weakSelf.model.password = model.password;
                    weakSelf.model.isKeepPwd = model.isKeepPwd;
                    if (model.isKeepPwd == NO) {
                        weakSelf.model.password = @"";
                        model.password = @"";
                    }
                    [[HWGlobalData shared] changeDevice:weakSelf.model];
                    
                } else {
                    if (model.isKeepPwd == NO) {
                        model.password = @"";
                    }
                    [[HWGlobalData shared] saveDevice:model];
                    
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (model.otherName.length == 0) {
                model.otherName = LocalString(@"device");
            }
            
            if (weakSelf.model) {
                weakSelf.model.curServiceItem = model.curServiceItem;
                weakSelf.model.deviceName = model.deviceName;
                weakSelf.model.otherName = model.otherName;
                weakSelf.model.port = model.port;
                weakSelf.model.account = model.account;
                weakSelf.model.password = model.password;
                weakSelf.model.isKeepPwd = model.isKeepPwd;
                if (model.isKeepPwd == NO) {
                    weakSelf.model.password = @"";
                    model.password = @"";
                }
                [[HWGlobalData shared] changeDevice:weakSelf.model];
                
            } else {
                if (model.isKeepPwd == NO) {
                    model.password = @"";
                }
                [[HWGlobalData shared] saveDevice:model];
                
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        

        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (model.otherName.length == 0) {
            model.otherName = LocalString(@"device");
        }
        
        if (weakSelf.model) {
            weakSelf.model.curServiceItem = model.curServiceItem;
            weakSelf.model.deviceName = model.deviceName;
            weakSelf.model.otherName = model.otherName;
            weakSelf.model.port = model.port;
            weakSelf.model.account = model.account;
            weakSelf.model.password = model.password;
            weakSelf.model.isKeepPwd = model.isKeepPwd;
            if (model.isKeepPwd == NO) {
                weakSelf.model.password = @"";
                model.password = @"";
            }
            [[HWGlobalData shared] changeDevice:weakSelf.model];
            
        } else {
            if (model.isKeepPwd == NO) {
                model.password = @"";
            }
            [[HWGlobalData shared] saveDevice:model];
            
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

//- (BOOL)isDomainHost:(NSString *)str {
//    NSArray *arr = [str componentsSeparatedByString:@"."];
//    if (arr.count < 3) {
//        return NO;
//    }
//    NSString *firststr = arr.firstObject;
//    if (![firststr isEqualToString:@"www"]) {
//        return NO;
//    }
//}
-(BOOL)isDomain:(NSString *)str {
    
    NSString *regex = @"^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:str];
    
}
- (BOOL)isIP4:(NSString *)ipStr {
    if (nil == ipStr) {
        return NO;
    }
    NSArray *ipArray = [ipStr componentsSeparatedByString:@"."];
    if (ipArray.count == 4) {
        for (NSString *ipnumberStr in ipArray) {
            int ipnumber = [ipnumberStr intValue];
            if (ipnumber < 0 || ipnumber > 255) {
                return NO;
            }
            
        }
        return YES;
    }
    return NO;
}


- (BOOL)isIP6:(NSString *)ipStr {
    if (nil == ipStr) {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LOGINALPHANUMCha] invertedSet];
    NSString *filtered = [[ipStr componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if (![ipStr isEqualToString:filtered]) {
        return NO;
    };
    
    NSArray *ipArray2 = [ipStr componentsSeparatedByString:@"::"];
    if (ipArray2.count == 2) {
        NSString *iparrayindex0 = ipArray2[0];
        NSString *iparrayindex1 = ipArray2[1];
        
        if (iparrayindex0.length == 0 && iparrayindex1.length == 0) {
            return YES;
        } else if (iparrayindex0.length > 0 && iparrayindex1.length == 0) {
            NSArray *ipArray = [iparrayindex0 componentsSeparatedByString:@":"];
            if (ipArray.count < 8) {
                
                NSInteger i = 0;
                
                for (NSString *ipnumberStr in ipArray) {
                    if (ipnumberStr.length == 0) {
                        
                        return NO;
                        
                    } else if(ipnumberStr.length > 0 && ipnumberStr.length < 5){
                        for (int index = 0; index < ipnumberStr.length; index++) {
                            NSString *indestr = [ipnumberStr substringWithRange:NSMakeRange(index, 1)];
                            if (indestr.integerValue < 0 || indestr.integerValue > 15) {
                                return NO;
                            }
                        }
                    } else {
                        return NO;
                    }
                    
                    
                    i++;
                }
                return YES;
            } else {
                return NO;
            }
        } else if (iparrayindex1.length > 0 && iparrayindex0.length == 0) {
            NSArray *ipArray = [iparrayindex1 componentsSeparatedByString:@":"];
            if (ipArray.count < 8) {
                NSInteger i = 0;
                for (NSString *ipnumberStr in ipArray) {
                    if (ipnumberStr.length == 0) {
                        return NO;
                    } else if(ipnumberStr.length > 0 && ipnumberStr.length < 5){
                        for (int index = 0; index < ipnumberStr.length; index++) {
                            NSString *indestr = [ipnumberStr substringWithRange:NSMakeRange(index, 1)];
                            if (indestr.integerValue < 0 || indestr.integerValue > 15) {
                                return NO;
                            }
                        }
                    } else {
                        return NO;
                    }
                    
                    
                    i++;
                }
                return YES;
            } else {
                return NO;
            }
        } else {
            NSArray *ipArray = [ipStr componentsSeparatedByString:@":"];
            if (ipArray.count < 9) {
                
                NSInteger i = 0;
                BOOL isYes = YES;
                for (NSString *ipnumberStr in ipArray) {
                    if (ipnumberStr.length == 0) {
                        if (isYes == NO) {
                            return NO;
                        }
                        isYes = NO;
                    } else if(ipnumberStr.length > 0 && ipnumberStr.length < 5){
                        for (int index = 0; index < ipnumberStr.length; index++) {
                            NSString *indestr = [ipnumberStr substringWithRange:NSMakeRange(index, 1)];
                            if (indestr.integerValue < 0 || indestr.integerValue > 15) {
                                return NO;
                            }
                        }
                    } else {
                        return NO;
                    }
                    
                    
                    i++;
                }
                return YES;
            } else {
                return NO;
            }
        }
        
        
        return NO;
    } else if (ipArray2.count == 1) {
        NSArray *ipArray = [ipStr componentsSeparatedByString:@":"];
        if (ipArray.count == 8) {
            NSInteger i = 0;
            for (NSString *ipnumberStr in ipArray) {
                
                if(ipnumberStr.length > 0 && ipnumberStr.length < 5){
                    for (int index = 0; index < ipnumberStr.length; index++) {
                        NSString *indestr = [ipnumberStr substringWithRange:NSMakeRange(index, 1)];
                        if (indestr.integerValue < 0 || indestr.integerValue > 15) {
                            return NO;
                        }
                    }
                } else {
                    return NO;
                }
                
                i++;
            }
            return YES;
        }
        return NO;
    } else {
        return NO;
    }
    
}


- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
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
