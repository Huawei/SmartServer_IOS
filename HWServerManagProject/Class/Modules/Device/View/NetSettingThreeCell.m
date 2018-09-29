//
//  NetSettingTwoCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingThreeCell.h"
#import "AddListOneCell.h"
#import "AddListCell.h"
#import "AddListTwoCell.h"
#import "NetIpVersionChangePopView.h"
#import "NetDNSChangePopView.h"

@interface NetSettingThreeCell()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) NetIpVersionChangePopView *pop1View;
@property (strong, nonatomic) NetDNSChangePopView *pop2View;

@property (strong, nonatomic) UIButton *checkSubmit1Btn;
@property (strong, nonatomic) UIButton *checkSubmit2Btn;
@property (strong, nonatomic) UIButton *checkSubmit3Btn;
@property (strong, nonatomic) UIButton *checkSubmit4Btn;

@property (copy, nonatomic) NSString *ipversion;
@property (assign, nonatomic) BOOL ipv4auto;
@property (copy, nonatomic) NSString *ipv4ipaddress;
@property (copy, nonatomic) NSString *ipv4subnetmask;
@property (copy, nonatomic) NSString *ipv4gateway;
@property (copy, nonatomic) NSString *ipv4macaddress;
@property (assign, nonatomic) BOOL ipv6auto;
@property (copy, nonatomic) NSString *ipv6ipadress;
@property (copy, nonatomic) NSString *ipv6prefixlen;
@property (copy, nonatomic) NSString *ipv6gateway;
@property (copy, nonatomic) NSString *ipv6linklocaladdress;
@property (copy, nonatomic) NSString *dnsmode;
@property (copy, nonatomic) NSString *dnspreferred;
@property (copy, nonatomic) NSString *dnsalternate;
@property (copy, nonatomic) NSString *domainName;

@end

@implementation NetSettingThreeCell {
    UITableViewController *tableViewController;
}

- (UITableView *)tableView {
    if (!_tableView) {
        tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        tableViewController.tableView.autoresizingMask = NO;
        _tableView = tableViewController.tableView;
        
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pop1View = [[[NSBundle mainBundle] loadNibNamed:@"NetIpVersionChangePopView" owner:nil options:nil] lastObject];
    self.pop2View = [[[NSBundle mainBundle] loadNibNamed:@"NetDNSChangePopView" owner:nil options:nil] lastObject];

}

- (UIButton *)checkSubmit1Btn {
    if (!_checkSubmit1Btn) {
        _checkSubmit1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkSubmit1Btn.frame = CGRectMake(ScreenWidth - 60, 11, 50, 28);
//        [_checkSubmit1Btn setImage:[UIImage imageNamed:@"one_checkSubmtiIcon"] forState:UIControlStateNormal];
        [_checkSubmit1Btn setTitle:[NSString stringWithFormat:@"%@",LocalString(@"submit")] forState:UIControlStateNormal];
        [_checkSubmit1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkSubmit1Btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkSubmit1Btn addTarget:self action:@selector(checkTrueAction:) forControlEvents:UIControlEventTouchUpInside];
        _checkSubmit1Btn.backgroundColor = RGBCOLOR(39, 177, 149);
        _checkSubmit1Btn.layer.cornerRadius = 3;
        _checkSubmit1Btn.layer.masksToBounds = YES;
    }
    return _checkSubmit1Btn;
}

- (UIButton *)checkSubmit2Btn {
    if (!_checkSubmit2Btn) {
        _checkSubmit2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkSubmit2Btn.frame = CGRectMake(ScreenWidth - 60, 11, 50, 28);
        //        [_checkSubmit1Btn setImage:[UIImage imageNamed:@"one_checkSubmtiIcon"] forState:UIControlStateNormal];
        [_checkSubmit2Btn setTitle:[NSString stringWithFormat:@"%@",LocalString(@"submit")] forState:UIControlStateNormal];
        [_checkSubmit2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkSubmit2Btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkSubmit2Btn addTarget:self action:@selector(checkTrueAction:) forControlEvents:UIControlEventTouchUpInside];
        _checkSubmit2Btn.backgroundColor = RGBCOLOR(39, 177, 149);
        _checkSubmit2Btn.layer.cornerRadius = 3;
        _checkSubmit2Btn.layer.masksToBounds = YES;
    }
    return _checkSubmit2Btn;
}

- (UIButton *)checkSubmit3Btn {
    if (!_checkSubmit3Btn) {
        _checkSubmit3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkSubmit3Btn.frame = CGRectMake(ScreenWidth - 60, 11, 50, 28);
        //        [_checkSubmit1Btn setImage:[UIImage imageNamed:@"one_checkSubmtiIcon"] forState:UIControlStateNormal];
        [_checkSubmit3Btn setTitle:[NSString stringWithFormat:@"%@",LocalString(@"submit")] forState:UIControlStateNormal];
        [_checkSubmit3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkSubmit3Btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkSubmit3Btn addTarget:self action:@selector(checkTrueAction:) forControlEvents:UIControlEventTouchUpInside];
        _checkSubmit3Btn.backgroundColor = RGBCOLOR(39, 177, 149);
        _checkSubmit3Btn.layer.cornerRadius = 3;
        _checkSubmit3Btn.layer.masksToBounds = YES;
    }
    return _checkSubmit3Btn;
}

- (UIButton *)checkSubmit4Btn {
    if (!_checkSubmit4Btn) {
        _checkSubmit4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkSubmit4Btn.frame = CGRectMake(ScreenWidth - 60, 11, 50, 28);
        //        [_checkSubmit1Btn setImage:[UIImage imageNamed:@"one_checkSubmtiIcon"] forState:UIControlStateNormal];
        [_checkSubmit4Btn setTitle:[NSString stringWithFormat:@"%@",LocalString(@"submit")] forState:UIControlStateNormal];
        [_checkSubmit4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkSubmit4Btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkSubmit4Btn addTarget:self action:@selector(checkTrueAction:) forControlEvents:UIControlEventTouchUpInside];
        _checkSubmit4Btn.backgroundColor = RGBCOLOR(39, 177, 149);
        _checkSubmit4Btn.layer.cornerRadius = 3;
        _checkSubmit4Btn.layer.masksToBounds = YES;
    }
    return _checkSubmit4Btn;
}

- (void)setController:(UIViewController *)controller {
    _controller = controller;
    if (!_tableView) {
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
        [self.tableView registerNib:[UINib nibWithNibName:@"AddListTwoCell" bundle:nil] forCellReuseIdentifier:@"AddListTwoCell"];
        
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
//        footerView.backgroundColor = [UIColor clearColor];
//        self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
//        self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
//        self.submitBtn.layer.cornerRadius = 4;
//        self.submitBtn.layer.masksToBounds = YES;
//        self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self.submitBtn setTitle:LocalString(@"submit") forState:UIControlStateNormal];
//        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [footerView addSubview:self.submitBtn];
        self.tableView.tableFooterView = footerView;
        [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView reloadData];
        [controller addChildViewController:tableViewController];
        
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getData];
        }];
          
    }
    
    tableViewController.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - 50);
    
}

- (void)checkTrueAction:(UIButton *)btn {
    
    [self.contentView endEditing:YES];
  
    if (btn == self.checkSubmit1Btn) {
        if (self.ipversion.length == 0) {
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ip_version_required")];
            return;
        }
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"ns_network_prompt_update_ip_version") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (!self.odata_id || self.odata_id.length == 0) {
                return ;
            }
            NSDictionary *oem = @{@"Huawei":@{@"IPVersion":[self.ipversion stringByReplacingOccurrencesOfString:@"+" withString:@"And"],@"DNSAddressOrigin":@"Static"}};
            NSDictionary *param = @{@"Oem":oem};
            [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
            [ABNetWorking patchWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:param success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"operationsuccess")];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            }];
        }]];
        [self.controller.navigationController presentViewController:alert animated:YES completion:nil];
    } else if (btn == self.checkSubmit2Btn) {
        //IPv4
        NSMutableDictionary *param = @{}.mutableCopy;
        if (!self.ipv4auto) {
            if (self.ipv4ipaddress.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_addr_required")];
                return;
            }
            if (![self isIP4:self.ipv4ipaddress]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_addr_illegal")];
                return;
            }
            
            if (self.ipv4subnetmask.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_mask_required")];
                return;
            }
            if (![self isIP4:self.ipv4subnetmask]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_mask_illegal")];
                return;
            }
            
            if (self.ipv4gateway.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_gateway_required")];
                return;
            }
            if (![self isIP4:self.ipv4gateway]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_gateway_illegal")];
                return;
            }
            
            NSArray *iPv4Addresses = @[@{@"Address":self.ipv4ipaddress,
                                         @"AddressOrigin":@"Static",
                                         @"Gateway":self.ipv4gateway,
                                         @"SubnetMask":self.ipv4subnetmask
                                         }];
            [param setObject:iPv4Addresses forKey:@"IPv4Addresses"];
        } else {
            NSArray *iPv4Addresses = @[@{@"AddressOrigin":@"DHCP"}];
            [param setObject:iPv4Addresses forKey:@"IPv4Addresses"];
        }
        
        
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"ns_network_prompt_update_ipv4_setting") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (!self.odata_id || self.odata_id.length == 0) {
                return ;
            }
            
            [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
            [ABNetWorking patchWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:param success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"operationsuccess")];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            }];
        }]];
        [self.controller.navigationController presentViewController:alert animated:YES completion:nil];
    } else if (btn == self.checkSubmit3Btn) {
        //IPv6
        NSMutableDictionary *param = @{}.mutableCopy;

        if (!self.ipv6auto) {
            if (self.ipv6ipadress.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_addr_required")];
                return;
            }
            if (![self isIP6:self.ipv6ipadress]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_addr_illegal")];
                return;
            }
            
            if (self.ipv6prefixlen.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_prefix_required")];
                return;
            }
            if (![self isPureInt:self.ipv6prefixlen]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_prefix_illegal")];
                return;
            }
            if (self.ipv6prefixlen.integerValue < 0 || self.ipv6prefixlen.integerValue > 128) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_prefix_illegal")];
                return;
            }
            
            if (self.ipv6gateway.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_gateway_required")];
                return;
            }
            if (![self isIP6:self.ipv6gateway]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_gateway_illegal")];
                return;
            }
            
            NSArray *iPv6StaticAddresses = @[@{@"Address":self.ipv6ipadress,@"PrefixLength":@(self.ipv6prefixlen.integerValue)}];
            [param setObject:iPv6StaticAddresses forKey:@"IPv6StaticAddresses"];
            
            NSArray *iPv6Addresses = @[@{@"AddressOrigin":@"Static"}];
            [param setObject:iPv6Addresses forKey:@"IPv6Addresses"];
            
            [param setObject:self.ipv6gateway forKey:@"IPv6DefaultGateway"];
            
        } else {
            NSArray *iPv6Addresses = @[@{@"AddressOrigin":@"DHCPv6"}];
            [param setObject:iPv6Addresses forKey:@"IPv6Addresses"];
        }
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"ns_network_prompt_update_ipv6_setting") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (!self.odata_id || self.odata_id.length == 0) {
                return ;
            }
            
            [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
            [ABNetWorking patchWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:param success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"operationsuccess")];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            }];
        }]];
        [self.controller.navigationController presentViewController:alert animated:YES completion:nil];
    } else if (btn == self.checkSubmit4Btn) {
        //DNS
        NSMutableDictionary *param = @{}.mutableCopy;

        if ([self.dnsmode isEqualToString:@"Static"]) {

            if (self.dnspreferred.length > 0) {
                if (![self isIP4:self.dnspreferred] && ![self isIP6:self.dnspreferred] ) {
                    [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_primary_dns_illegal")];
                    return;
                }
            }

            if (self.dnsalternate.length > 0 && ![self isIP4:self.dnsalternate]) {
                if (![self isIP4:self.dnsalternate] && ![self isIP6:self.dnsalternate] ) {
                    [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_alternative_dns_illegal")];
                    return;
                }
            }
            

            NSDictionary *oem = @{@"Huawei":@{@"DNSAddressOrigin":@"Static"}};
            [param setObject:oem forKey:@"Oem"];
            
            NSString *FQDN = self.dataDic[@"FQDN"];
            if (FQDN.isSureString && FQDN.length > 0) {
                NSString *hostname = self.dataDic[@"HostName"];
                if (self.didGetHostNameBlock) {
                    hostname = self.didGetHostNameBlock();
                }
                if (!hostname) {
                    hostname = @"";
                }
                [param setObject:[NSString stringWithFormat:@"%@.%@",hostname,self.domainName] forKey:@"FQDN"];
            } else {
                
                NSString *hostname = self.dataDic[@"HostName"];
                if (self.didGetHostNameBlock) {
                    hostname = self.didGetHostNameBlock();
                }
                [param setObject:[NSString stringWithFormat:@"%@.%@",hostname,self.domainName] forKey:@"FQDN"];
            }
            
            NSArray *NameServers = @[self.dnspreferred,self.dnsalternate];
            [param setObject:NameServers forKey:@"NameServers"];
            
        } else {
       
            NSDictionary *oem = @{@"Huawei":@{@"DNSAddressOrigin":self.dnsmode}};
            [param setObject:oem forKey:@"Oem"];
            
        }
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"ns_network_prompt_update_dns_setting") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (!self.odata_id || self.odata_id.length == 0) {
                return ;
            }
            
            [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
            [ABNetWorking patchWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:param success:^(NSDictionary *result) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"operationsuccess")];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            }];
        }]];
        [self.controller.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.ipversion = @"";
    self.ipv4auto = NO;
    self.ipv4ipaddress = @"";
    self.ipv4subnetmask = @"";
    self.ipv4gateway = @"";
    self.ipv4macaddress = @"";
    self.ipv6auto = NO;
    self.ipv6ipadress = @"";
    self.ipv6prefixlen = @"";
    self.ipv6gateway = @"";
    self.ipv6linklocaladdress = @"";
    self.dnsmode = @"";
    self.dnspreferred = @"";
    self.dnsalternate = @"";
    self.domainName = @"";
    
    if (dataDic) {
        
        NSString *fqdn = dataDic[@"FQDN"];
        if (fqdn.isSureString) {
            NSMutableArray *temparrfqdn = [fqdn componentsSeparatedByString:@"."].mutableCopy;
            if (temparrfqdn.count > 0) {
                [temparrfqdn removeObjectAtIndex:0];
                if (temparrfqdn.count > 0) {
                    self.domainName = [temparrfqdn componentsJoinedByString:@"."];
                }
            }
        }
        
        NSDictionary *oem = dataDic[@"Oem"];
        if (oem.isSureDictionary) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSString *iPVersion = huawei[@"IPVersion"];
                self.ipversion = iPVersion;
            }
        }
        
        NSArray *IPv4Addresses = dataDic[@"IPv4Addresses"];
        NSDictionary *IPv4Addresse = nil;
        if (IPv4Addresses.isSureArray && IPv4Addresses.count > 0) {
            IPv4Addresse = [IPv4Addresses firstObject];
            NSString *AddressOrigin = IPv4Addresse[@"AddressOrigin"];
            if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"Static"]) {
                self.ipv4auto = NO;
            } else if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"DHCP"]) {
                self.ipv4auto = YES;
            } else {
                self.ipv4auto = NO;
            }
            NSString *Address = IPv4Addresse[@"Address"];
            if (Address.isSureString) {
                self.ipv4ipaddress = Address;
            }
            
            NSString *Gateway = IPv4Addresse[@"Gateway"];
            if (Gateway.isSureString) {
                self.ipv4gateway = Gateway;
            }
            
            NSString *SubnetMask = IPv4Addresse[@"SubnetMask"];
            if (SubnetMask.isSureString) {
                self.ipv4subnetmask = SubnetMask;
            }
            
        } else {
            self.ipv4auto = NO;
        }
        
        NSString *PermanentMACAddress = dataDic[@"PermanentMACAddress"];
        if (PermanentMACAddress.isSureString) {
            self.ipv4macaddress = PermanentMACAddress;
        }
        
        NSArray *IPv6Addresses = dataDic[@"IPv6Addresses"];
        NSDictionary *IPv6Addresse = nil;
        if (IPv6Addresses.isSureArray && IPv6Addresses.count > 0) {
            IPv6Addresse = [IPv6Addresses firstObject];
            NSString *AddressOrigin = IPv6Addresse[@"AddressOrigin"];
            if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"Static"]) {
                self.ipv6auto = NO;
            } else if (AddressOrigin.isSureString && [AddressOrigin isEqualToString:@"DHCPv6"]) {
                self.ipv6auto = YES;
            } else {
                self.ipv6auto = NO;
            }
        } else {
            self.ipv6auto = NO;
        }
        
        NSArray *IPv6StaticAddresses = dataDic[@"IPv6StaticAddresses"];
        NSDictionary *IPv6StaticAddresse = nil;
        if (IPv6StaticAddresses.isSureArray && IPv6StaticAddresses.count > 0) {
            IPv6StaticAddresse = [IPv6StaticAddresses firstObject];
            
            NSString *Address = IPv6StaticAddresse[@"Address"];
            if (Address.isSureString) {
                self.ipv6ipadress = Address;
            }
            
            NSString *PrefixLength = IPv6StaticAddresse[@"PrefixLength"];
            if (PrefixLength && ![PrefixLength isKindOfClass:[NSNull class]]) {
                self.ipv6prefixlen = [NSString stringWithFormat:@"%@",PrefixLength];
            }
        }
        
        if (IPv6Addresses.isSureArray && IPv6Addresses.count > 1) {
            NSDictionary *IPv6Addresses1 = IPv6Addresses[1];
            
            NSString *Address = IPv6Addresses1[@"Address"];
            if (Address.isSureString) {
                self.ipv6linklocaladdress = Address;
            }
        }
        
        NSString *IPv6DefaultGateway = dataDic[@"IPv6DefaultGateway"];
        if (IPv6DefaultGateway.isSureString) {
            self.ipv6gateway = IPv6DefaultGateway;
        }
        
        NSDictionary *Oem = dataDic[@"Oem"];
        if (Oem.isSureDictionary) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSString *DNSAddressOrigin = huawei[@"DNSAddressOrigin"];
                if (DNSAddressOrigin.isSureString) {
                    self.dnsmode = DNSAddressOrigin;
                }
                
            }
        }

        NSArray *NameServers = dataDic[@"NameServers"];
        if (NameServers.isSureArray && NameServers.count > 0) {
            NSString *NameServers0 = NameServers[0];
            if (NameServers0.isSureString) {
                self.dnspreferred = NameServers0;
            }
            if (NameServers.count > 1) {
                NSString *NameServers1 = NameServers[1];
                if (NameServers1.isSureString) {
                    self.dnsalternate = NameServers1;
                }
            }
        }
        
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        
        if ([self.ipversion rangeOfString:@"IPv4"].location == NSNotFound) {
            return 0;
        }
       
        if (self.ipv4auto) {
            return 1;
        }
        return 5;
    } else if (section == 2) {
        if ([self.ipversion rangeOfString:@"IPv6"].location == NSNotFound) {
            return 0;
        }
        if (self.ipv6auto) {
            return 1;
        }
        return 5;
    } else {
        if ([self.dnsmode isEqualToString:@"Static"]) {
            return 4;
            
        }
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 45;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if ([self.ipversion rangeOfString:@"IPv4"].location == NSNotFound) {
            return 0.01;
        }
    } else if (section == 2) {
        if ([self.ipversion rangeOfString:@"IPv6"].location == NSNotFound) {
            return 0.01;
        }
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.clipsToBounds = YES;
    secView.backgroundColor = NormalApp_BackgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5, ScreenWidth-30, 45)];
    if (section == 0) {
        label.text = LocalString(@"ns_network_ip_version_setting");
    } else if(section == 1) {
        label.text = LocalString(@"ns_network_label_ipv4");
        
    } else if(section == 2) {
        label.text = LocalString(@"ns_network_label_ipv6");

    }else if(section == 3) {
        label.text = @"DNS";

    }
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    
    if (section == 0) {
        [secView addSubview:self.checkSubmit1Btn];
    } else if (section == 1) {
        [secView addSubview:self.checkSubmit2Btn];
    } else if (section == 2) {
        [secView addSubview:self.checkSubmit3Btn];
    } else if (section == 3) {
        [secView addSubview:self.checkSubmit4Btn];
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
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
        cell.leftLabel.text = LocalString(@"ns_network_ip_version");
        cell.contentLabel.text = @"";
        
        NSString *str = nil;
        if ([self.ipversion rangeOfString:@"IPv4"].location != NSNotFound) {
            str = @"IPv4";
        }
        if ([self.ipversion rangeOfString:@"IPv6"].location != NSNotFound) {
            if (str) {
                str = [NSString stringWithFormat:@"IPv4+%@",@"IPv6"];
            } else {
                str = @"IPv6";
            }
        }
        cell.contentLabel.text = str;
        return cell;
    } else if (indexPath.section == 1) {
        AddListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListOneCell"];
        cell.inputTF.textColor = NormalApp_TableView_Title_Style_Color;
        cell.inputTF.placeholder = @"";
        cell.inputTF.text = @"";
        cell.inputTF.userInteractionEnabled = YES;
        switch (indexPath.row) {
            case 0: {
                AddListTwoCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
                cell2.leftLabel.text = LocalString(@"ns_network_label_dhcp");
                if (self.ipv4auto) {
                    cell2.onOffSwitch.on = YES;
                } else {
                    cell2.onOffSwitch.on = NO;
                }
                __weak typeof(self) weakSelf = self;
                cell2.didChangeStatusIndexBlock = ^(BOOL onOff, NSInteger row) {
                    weakSelf.ipv4auto = onOff;
                    [weakSelf.tableView reloadData];
                };
                return cell2;
            }
                
                break;
            case 1: {
                cell.leftLabel.text = LocalString(@"ns_network_label_ip_address");
                cell.inputTF.text = self.ipv4ipaddress;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.ipv4ipaddress = value;
                };
            }
                break;
            case 2: {
                cell.leftLabel.text = LocalString(@"ns_network_label_subnet_mask");
                    cell.inputTF.text = self.ipv4subnetmask;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.ipv4subnetmask = value;
                };
            }
                break;
            case 3: {
                cell.leftLabel.text = LocalString(@"ns_network_label_gateway");
                    cell.inputTF.text = self.ipv4gateway;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.ipv4gateway = value;
                };
            }
                break;
            case 4: {
                cell.leftLabel.text = LocalString(@"ns_network_label_mac");
                cell.inputTF.text = self.ipv4macaddress;
                cell.inputTF.userInteractionEnabled = NO;
            }
                break;
            default:
                break;
        }
        return cell;
    } else if (indexPath.section == 2) {
        AddListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListOneCell"];
        cell.inputTF.textColor = NormalApp_TableView_Title_Style_Color;
        cell.inputTF.placeholder = @"";
        cell.inputTF.text = @"";
        cell.inputTF.userInteractionEnabled = YES;
        switch (indexPath.row) {
            case 0: {
                AddListTwoCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"AddListTwoCell"];
                cell2.leftLabel.text = LocalString(@"ns_network_label_dhcp");
                if (self.ipv6auto) {
                    cell2.onOffSwitch.on = YES;
                } else {
                    cell2.onOffSwitch.on = NO;
                }
                __weak typeof(self) weakSelf = self;
                cell2.didChangeStatusIndexBlock = ^(BOOL onOff, NSInteger row) {
                    weakSelf.ipv6auto = onOff;
                    [weakSelf.tableView reloadData];
                };
                return cell2;
            }
                break;
            case 1: {
                cell.leftLabel.text = LocalString(@"ns_network_label_ip_address");
                    cell.inputTF.text = self.ipv6ipadress;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.ipv6ipadress = value;
                };
            }
                break;
            case 2: {
                cell.leftLabel.text = LocalString(@"ns_network_label_prefix_len");
                cell.inputTF.text = self.ipv6prefixlen;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.ipv6prefixlen = value;
                };
            }
                break;
            case 3: {
                cell.leftLabel.text = LocalString(@"ns_network_label_gateway");
                    cell.inputTF.text = self.ipv6gateway;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.ipv6gateway = value;
                };
            }
                break;
            case 4: {
                cell.leftLabel.text = LocalString(@"ns_network_label_link_local_address");
                    cell.inputTF.text = self.ipv6linklocaladdress;
                cell.inputTF.userInteractionEnabled = NO;
            }
                break;
            default:
                break;
        }
        return cell;

    } else {
        AddListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListOneCell"];
        cell.inputTF.textColor = NormalApp_TableView_Title_Style_Color;
        cell.inputTF.placeholder = @"";
        cell.inputTF.text = @"";
        cell.inputTF.userInteractionEnabled = YES;
        switch (indexPath.row) {
            case 0: {
                
                AddListCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
                cell2.leftLabel.text = LocalString(@"ns_network_label_dns_setup_method");
                cell2.contentLabel.text = @"";
                cell2.contentLabel.text = self.dnsmode;
                
                if ([self.dnsmode isEqualToString:@"Static"]) {
                    cell2.contentLabel.text = LocalString(@"ns_network_dns_addr_origin_static");
                } else if ([self.dnsmode isEqualToString:@"IPv4"]) {
                    cell2.contentLabel.text = LocalString(@"ns_network_dns_addr_origin_ipv4");
                } else if ([self.dnsmode isEqualToString:@"IPv6"]) {
                    cell2.contentLabel.text = LocalString(@"ns_network_dns_addr_origin_ipv6");
                }
                
                
                return cell2;

            }
                break;
            case 2: {
                cell.leftLabel.text = LocalString(@"ns_network_label_primary_DNS");
                cell.inputTF.text = self.dnspreferred;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.dnspreferred = value;
                };
            }
                break;
            case 3: {
                cell.leftLabel.text = LocalString(@"ns_network_label_alternative_DNS");
                cell.inputTF.text = self.dnsalternate;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.dnsalternate = value;
                };
            }
                break;
            case 1: {
                cell.leftLabel.text = LocalString(@"ns_network_label_domain");
                cell.inputTF.text = self.domainName;
                cell.didSureInputBlock = ^(NSString *value) {
                    weakSelf.domainName = value;
                };
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        [self.controller.navigationController.view addSubview:self.pop1View];
        [self.pop1View reloadData];
        self.pop1View.didSelectIpVersionBlock = ^(NSString *value, NSInteger popRow) {
            weakSelf.ipversion = value;
            [weakSelf.tableView reloadData];
        };
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        __weak typeof(self) weakSelf = self;
        [self.controller.navigationController.view addSubview:self.pop2View];
        self.pop2View.hasipv4 = self.ipv4auto;
        self.pop2View.hasipv6 = self.ipv6auto;
        
        if ([self.ipversion rangeOfString:@"IPv4"].location == NSNotFound) {
            self.pop2View.hasipv4 = NO;
        }
        if ([self.ipversion rangeOfString:@"IPv6"].location == NSNotFound) {
            self.pop2View.hasipv6 = NO;
        }
        
        [self.pop2View reloadData];
        self.pop2View.didSelecDNSBlock = ^(NSString *value, NSInteger popRow) {
            if ([value isEqualToString:LocalString(@"ns_network_dns_addr_origin_static")]) {
                weakSelf.dnsmode = @"Static";
            } else if ([value isEqualToString:LocalString(@"ns_network_dns_addr_origin_ipv4")]) {
                weakSelf.dnsmode = @"IPv4";
            } else if ([value isEqualToString:LocalString(@"ns_network_dns_addr_origin_ipv6")]) {
                weakSelf.dnsmode = @"IPv6";
            }
            [weakSelf.tableView reloadData];
        };
    }
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    weakSelf.odata_id = odata_id;
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        
                        weakSelf.dataDic = result14;
                        if (weakSelf.didRefreshNetBlock) {
                            weakSelf.didRefreshNetBlock(result14, odata_id);
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                    break;
                }
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)submitAction {
    [self.contentView endEditing:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (self.ipversion.length == 0) {
        [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ip_version_required")];
        return;
    }
    
    NSDictionary *oem = @{@"Huawei":@{@"IPVersion":self.ipversion}};
    [param setObject:oem forKey:@"Oem"];
    
    if ([self.ipversion rangeOfString:@"IPv4"].location != NSNotFound) {
        if (!self.ipv4auto) {
            if (self.ipv4ipaddress.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_addr_required")];
                return;
            }
            if (![self isIP4:self.ipv4ipaddress]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_addr_illegal")];
                return;
            }
            
            if (self.ipv4subnetmask.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_mask_required")];
                return;
            }
            if (![self isIP4:self.ipv4subnetmask]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_mask_illegal")];
                return;
            }
            
            if (self.ipv4gateway.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_gateway_required")];
                return;
            }
            if (![self isIP4:self.ipv4gateway]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv4_gateway_illegal")];
                return;
            }
            
            NSArray *iPv4Addresses = @[@{@"Address":self.ipv4ipaddress,
                                         @"AddressOrigin":@"Static",
                                         @"Gateway":self.ipv4gateway,
                                         @"SubnetMask":self.ipv4subnetmask
                                         }];
            [param setObject:iPv4Addresses forKey:@"IPv4Addresses"];
        } else {
            NSArray *iPv4Addresses = @[@{@"AddressOrigin":@"DHCP"}];
            [param setObject:iPv4Addresses forKey:@"IPv4Addresses"];
        }
    }
    if ([self.ipversion rangeOfString:@"IPv6"].location != NSNotFound) {
        if (!self.ipv6auto) {
            if (self.ipv6ipadress.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_addr_required")];
                return;
            }
            if (![self isIP6:self.ipv6ipadress]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_addr_illegal")];
                return;
            }
            
            if (self.ipv6prefixlen.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_prefix_required")];
                return;
            }
            if (![self isPureInt:self.ipv6prefixlen]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_prefix_illegal")];
                return;
            }
            if (self.ipv6prefixlen.integerValue < 0 || self.ipv6prefixlen.integerValue > 128) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_prefix_illegal")];
                return;
            }
            
            if (self.ipv6gateway.length == 0) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_gateway_required")];
                return;
            }
            if (![self isIP6:self.ipv6gateway]) {
                [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_ipv6_gateway_illegal")];
                return;
            }
            
            NSArray *iPv6StaticAddresses = @[@{@"Address":self.ipv6ipadress,@"PrefixLength":@(self.ipv6prefixlen.integerValue)}];
            [param setObject:iPv6StaticAddresses forKey:@"IPv6StaticAddresses"];
            
            NSArray *iPv6Addresses = @[@{@"AddressOrigin":@"Static"}];
            [param setObject:iPv6Addresses forKey:@"IPv6Addresses"];
            
            [param setObject:self.ipv6gateway forKey:@"IPv6DefaultGateway"];
            
        } else {
            NSArray *iPv6Addresses = @[@{@"AddressOrigin":@"DHCPv6"}];
            [param setObject:iPv6Addresses forKey:@"IPv6Addresses"];
        }
        
    }
    
    
    
    
    if ([self.dnsmode isEqualToString:@"Static"]) {
        if (self.dnspreferred.length == 0) {
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_primary_dns_required")];
            return;
        }
        
        if (![self isIP4:self.dnspreferred]) {
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_primary_dns_illegal")];
            return;
        }
        
        if (self.dnsalternate.length == 0) {
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_alternative_dns_required")];
            return;
        }
        
        if (![self isIP4:self.dnsalternate]) {
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"ns_network_error_alternative_dns_illegal")];
            return;
        }
        
        NSDictionary *Oem = param[@"Oem"];
        if (Oem) {
            NSDictionary *oem = @{@"Huawei":@{@"IPVersion":[self.ipversion stringByReplacingOccurrencesOfString:@"+" withString:@"And"],@"DNSAddressOrigin":@"Static"}};
            [param setObject:oem forKey:@"Oem"];
        } else {
            NSDictionary *oem = @{@"Huawei":@{@"DNSAddressOrigin":@"Static"}};
            [param setObject:oem forKey:@"Oem"];
        }
        
        NSString *FQDN = self.dataDic[@"FQDN"];
        if (FQDN.isSureString && FQDN.length > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[FQDN componentsSeparatedByString:@"."]];
            NSString *hostname = self.dataDic[@"HostName"];
            if (self.didGetHostNameBlock) {
                hostname = self.didGetHostNameBlock();
            }
            if (!hostname) {
                hostname = @"";
            }
            [arr replaceObjectAtIndex:0 withObject:hostname];
            [param setObject:[arr componentsJoinedByString:@"."] forKey:@"FQDN"];
        } else {
            
            NSString *hostname = self.dataDic[@"HostName"];
            if (self.didGetHostNameBlock) {
                hostname = self.didGetHostNameBlock();
            }
            [param setObject:[NSString stringWithFormat:@"%@.",hostname] forKey:@"FQDN"];
        }
        
        NSArray *NameServers = @[self.dnspreferred,self.dnsalternate];
        [param setObject:NameServers forKey:@"NameServers"];

    } else {
        NSDictionary *Oem = param[@"Oem"];
        if (Oem) {
            NSDictionary *oem = @{@"Huawei":@{@"IPVersion":self.ipversion,@"DNSAddressOrigin":self.dnsmode}};
            [param setObject:oem forKey:@"Oem"];
        } else {
            NSDictionary *oem = @{@"Huawei":@{@"DNSAddressOrigin":self.dnsmode}};
            [param setObject:oem forKey:@"Oem"];
        }
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"alerttitle") message:LocalString(@"ns_network_prompt_update_ip_setting") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self.odata_id || self.odata_id.length == 0) {
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
        [ABNetWorking patchWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:param success:^(NSDictionary *result) {
            [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"operationsuccess")];
            
//            [weakSelf getData];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
        }];
    }]];
    [self.controller.navigationController presentViewController:alert animated:YES completion:nil];
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
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
