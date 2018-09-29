//
//  HardwareInfoOneSubCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoOneSubCell.h"

@implementation HardwareInfoOneSubCell

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
    
    self.label1.text = [NSString stringWithFormat:@"%@",data[@"DeviceLocator"]];
    
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
    
    self.label3.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_memo_label_type"),data[@"MemoryDeviceType"]];
    self.label4.text = [NSString stringWithFormat:@"%@：%@ MB",LocalString(@"hardware_memo_label_capacity"),data[@"CapacityMiB"]];
    self.label5.text = [NSString stringWithFormat:@"%@：%@ MHz",LocalString(@"hardware_memo_label_speed"),data[@"OperatingSpeedMhz"]];
    self.label6.text = [NSString stringWithFormat:@"%@：%@ bit",LocalString(@"hardware_memo_label_width_bit"),data[@"DataWidthBits"]];
    self.label7.text = [NSString stringWithFormat:@"%@：%@ rank",LocalString(@"hardware_memo_label_rank_count"),data[@"RankCount"]];
    
    NSDictionary *oem = data[@"Oem"];
    if (oem.isSureDictionary) {
        NSDictionary *huawei = oem[@"Huawei"];
        if (huawei.isSureDictionary) {
            self.label8.text = [NSString stringWithFormat:@"%@：%@ mV",LocalString(@"hardware_memo_label_min_voltage"),huawei[@"MinVoltageMillivolt"]];
            self.label12.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_memo_label_technology"),huawei[@"Technology"]];
            self.label13.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_cpu_label_position"),huawei[@"Position"]];

        } else {
            self.label8.text = [NSString stringWithFormat:@"%@：",LocalString(@"hardware_memo_label_min_voltage")];
            self.label12.text = [NSString stringWithFormat:@"%@：",LocalString(@"hardware_memo_label_technology")];
        }
        
    } else {
        self.label8.text = [NSString stringWithFormat:@"%@：",LocalString(@"hardware_memo_label_min_voltage")];
        self.label12.text = [NSString stringWithFormat:@"%@：",LocalString(@"hardware_memo_label_technology")];
    }
    
    self.label9.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_memo_label_manufacturer"),data[@"Manufacturer"]];
    self.label10.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_memo_label_serial_no"),data[@"SerialNumber"]];
    NSString *partnumber = data[@"PartNumber"];
    if (partnumber && ![partnumber isKindOfClass:[NSNull class]]) {
        self.label11.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_memo_label_part_no"),partnumber];
    } else {
        self.label11.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_memo_label_part_no"),@"N/A"];

    }

}


@end
