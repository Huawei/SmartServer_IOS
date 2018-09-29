//
//  NetSettingOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "PowerSwitchMainTwoCell.h"

@interface PowerSwitchMainTwoCell()<UITextFieldDelegate>

@property (strong, nonatomic) UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation PowerSwitchMainTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = NormalApp_BackgroundColor;
    self.titleLabel.text = LocalString(@"setsafepowerofftimeout");
    self.desLabel.text = LocalString(@"powerofftimeoutdes");
    self.leftLabel.text = LocalString(@"timeout");
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(25, 150, ScreenWidth - 50, 40);
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LOGINNUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];

}

- (void)submitAction {
    [self.contentView endEditing:YES];
    if (self.inputTF.text.length == 0 || self.inputTF.text.integerValue < 10 || self.inputTF.text.integerValue > 6000) {
        [self.contentView makeToast:LocalString(@"powerofftimeoutpla")];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking patchWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"Oem":@{@"Huawei":@{@"SafePowerOffTimoutSeconds":@(self.inputTF.text.integerValue)}}} success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        BLLog(@"%@",result);
        
        NSDictionary *oem = result[@"Oem"];
        if (oem && [oem isKindOfClass:[NSDictionary class]]) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSNumber *SafePowerOffTimoutSeconds = huawei[@"SafePowerOffTimoutSeconds"];
                if (SafePowerOffTimoutSeconds != nil && ![SafePowerOffTimoutSeconds isKindOfClass:[NSNull class]] && SafePowerOffTimoutSeconds.integerValue == weakSelf.inputTF.text.integerValue) {
                    [weakSelf.contentView makeToast:LocalString(@"operationsuccess")];
                } else {
                    [weakSelf.contentView makeToast:LocalString(@"operationfail")];
                }
                
            } else {
                [weakSelf.contentView makeToast:LocalString(@"operationfail")];
            }
        } else {
            [weakSelf.contentView makeToast:LocalString(@"operationfail")];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        
    }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setSafePowerOffTimoutSeconds:(NSNumber *)safePowerOffTimoutSeconds {
    _safePowerOffTimoutSeconds = safePowerOffTimoutSeconds;
    self.inputTF.text = safePowerOffTimoutSeconds.stringValue;
}

- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    
    
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.contentScrollView.mj_header endRefreshing];
        
        NSDictionary *Oem = result[@"Oem"];
        if (Oem.isSureDictionary) {
            NSDictionary *huawei = Oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSNumber *SafePowerOffTimoutSeconds = huawei[@"SafePowerOffTimoutSeconds"];
                if (SafePowerOffTimoutSeconds != nil && ![SafePowerOffTimoutSeconds isKindOfClass:[NSNull class]]) {
                    weakSelf.safePowerOffTimoutSeconds = SafePowerOffTimoutSeconds;
                }
                
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        [weakSelf.contentScrollView.mj_header endRefreshing];
    }];
}

@end
