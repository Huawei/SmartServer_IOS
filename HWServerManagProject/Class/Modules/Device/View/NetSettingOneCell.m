//
//  NetSettingOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingOneCell.h"

@interface NetSettingOneCell()<UITextFieldDelegate>

@property (strong, nonatomic) UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation NetSettingOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = NormalApp_BackgroundColor;
    
    self.titleLabel.text = LocalString(@"ns_hostname_section_name");
    self.leftLabel.text = LocalString(@"ns_hostname_label_hostname");
    
    self.desLabel.frame = CGRectMake(20, 100, ScreenWidth-40, 100);
    self.desLabel.text = LocalString(@"ns_network_hint_hostname");
    [self.desLabel sizeToFit];
    

    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(25, self.desLabel.bottom + 30, ScreenWidth - 50, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"submit") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentScrollView addSubview:self.submitBtn];
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    self.contentScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
}

- (BOOL)checkText:(NSString *)string {
    if (string.length > 64 || string.length == 0) {
        return NO;
    }
    
    if ([string hasPrefix:@"-"]) {
        return NO;
    }
    if ([string hasSuffix:@"-"]) {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LOGINALPHANUMHostname] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        return NO;
    };
    return YES;
}

- (void)submitAction {
    [self.contentView endEditing:YES];
    
    if (![self checkText:self.inputTF.text]) {
        [self.contentView makeToast:LocalString(@"ns_network_msg_illegal_hostname")];
        return;
    }
    
    if (self.odata_id.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
        __weak typeof(self) weakSelf = self;
        [ABNetWorking patchWithUrlWithAction:[self.odata_id substringWithRange:NSMakeRange(1, self.odata_id.length-1)] parameters:@{@"HostName":self.inputTF.text} success:^(NSDictionary *result) {
            BLLog(@"%@",result);
            [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
            
            [weakSelf getData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
            NSArray *Members = result[@"Members"];
            
            if (Members && [Members isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in Members) {
                    NSString *odata_id = dic[@"@odata.id"];
                    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                        weakSelf.odata_id = odata_id;
                        [weakSelf submitAction];
                        break;
                    }
                }
            }
            
        } failure:^(NSError *error) {
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setHostName:(NSString *)hostName {
    _hostName = hostName;
    self.inputTF.text = hostName;
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.contentScrollView.mj_header endRefreshing];
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    weakSelf.odata_id = odata_id;
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {

                         weakSelf.hostName = [NSString stringWithFormat:@"%@",result14[@"HostName"]];
                        if (weakSelf.didRefreshHostBlock) {
                            weakSelf.didRefreshHostBlock(result14,odata_id);
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                    break;
                }
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.contentScrollView.mj_header endRefreshing];
    }];
}

@end
