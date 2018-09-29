//
//  HardwareInfoOneSubCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoThreeSubCell.h"

@implementation HardwareInfoThreeSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    self.label1.text = [NSString stringWithFormat:@"%@",data[@"Name"]];
    
    NSDictionary *status = data[@"Status"];
    self.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
    if (status.isSureDictionary) {
        NSString *health = status[@"Health"];
        if (health.isSureString) {
            if ([health isEqualToString:@"OK"]) {
                self.label2.text = LocalString(@"ok");
                self.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
            } else  if ([health isEqualToString:@"Warning"]) {
                self.label2.text = LocalString(@"warning");
                self.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
                
            } else {
                self.label2.text = LocalString(@"critical");
                self.iconIMV.image = [UIImage imageNamed:@"one_health_icon1"];
            }
        }
        
    } else {
        self.label2.text = @"";
        self.iconIMV.image = nil;
    }
    
    NSString *label3Str = data[@"Manufacturer"];
    self.label3.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_manufacturer"),label3Str.objectWitNoNull];
    NSString *label4Str = data[@"Model"];
    self.label4.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_model"),label4Str.objectWitNoNull];
    NSString *label5Str = data[@"PartNumber"];
    self.label5.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_part_no"),label5Str.objectWitNoNullWithNA];
    NSString *label6Str = data[@"SerialNumber"];
    self.label6.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_serial_no"),label6Str.objectWitNoNull];
    NSString *label7Str = data[@"PowerCapacityWatts"];
    self.label7.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_capacity_watts"),label7Str.objectWitNoNull];
    NSString *supplytype = data[@"PowerSupplyType"];
    if (supplytype.isSureString) {
        
        self.label8.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_supply_type"),[supplytype stringByReplacingOccurrencesOfString:@"or" withString:@"/"]];
    } else {
        self.label8.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_supply_type"),@""];

    }
    self.label9.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_power_label_firmware_version"),data[@"FirmwareVersion"]];
 
}

@end
