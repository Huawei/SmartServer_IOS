//
//  HardwareInfoOneSubCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareINetPortCell.h"

@implementation HardwareINetPortCell

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
    
    self.label1.text = [NSString stringWithFormat:@"Port %@",data[@"PhysicalPortNumber"]];
    
    NSString *LinkStatus = data[@"LinkStatus"];
    self.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
    if (LinkStatus.isSureString && [LinkStatus isEqualToString:@"Up"]) {
        self.label2.text = LocalString(@"hardware_network_port_link_status_up");
        self.iconIMV.image = [UIImage imageNamed:@"one_health_icon0"];
       
    } else if (LinkStatus.isSureString && [LinkStatus isEqualToString:@"Down"]) {
        self.label2.text = LocalString(@"hardware_network_port_link_status_down");
        self.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
    } else {
        self.label2.text = LocalString(@"hardware_network_port_link_status_down");
        self.iconIMV.image = [UIImage imageNamed:@"one_health_icon2"];
        
    }
    NSArray *AssociatedNetworkAddresses = data[@"AssociatedNetworkAddresses"];
    if (AssociatedNetworkAddresses.isSureArray && AssociatedNetworkAddresses.count > 0) {
        self.label3.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"hardware_network_port_label_mac_addr"),AssociatedNetworkAddresses[0]];
    } else {
        self.label3.text = [NSString stringWithFormat:@"%@：",LocalString(@"hardware_network_port_label_mac_addr")];

    }
    NSDictionary *oem = data[@"Oem"];
    if (oem && [oem isKindOfClass:[NSDictionary class]]) {
        NSDictionary *huawei = oem[@"Huawei"];
        if (huawei.isSureDictionary) {
            NSString *PortType = huawei[@"PortType"];
            if (PortType.isSureString && [PortType isEqualToString:@"ElectricalPort"]) {
                self.label4.text = [NSString stringWithFormat:@"%@：%@ ",LocalString(@"hardware_network_port_label_port_type"),LocalString(@"hardware_network_port_port_type_electrical")];
            } else if (PortType.isSureString && [PortType isEqualToString:@"OpticalPort"]) {
                self.label4.text = [NSString stringWithFormat:@"%@：%@ ",LocalString(@"hardware_network_port_label_port_type"),LocalString(@"hardware_network_port_port_type_optical")];
            } else {
                self.label4.text = [NSString stringWithFormat:@"%@： ",LocalString(@"hardware_network_port_label_port_type")];

            }
            
        }
    }
    
    
}


@end
