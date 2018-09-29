//
//  HealthEventsCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "SysLogEventsCell.h"

@implementation SysLogEventsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowdown"] forState:UIControlStateNormal];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowdown"] forState:UIControlStateHighlighted];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowup"] forState:UIControlStateSelected];
    [self.arrowButton setImage:[UIImage imageNamed:@"one_health_arrowup"] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void)setSysLogModel:(SysLogModel *)sysLogModel {
    _sysLogModel = sysLogModel;
    if (sysLogModel.isShowAll) {
        self.resolutionLabel.numberOfLines = 0;
    } else {
        self.resolutionLabel.numberOfLines = 1;
    }
    
    self.codeLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventcode"),sysLogModel.EventId];
    self.desLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventdescription"),sysLogModel.Message];
    self.timeLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventhandtime"),sysLogModel.Created];
    self.resolutionLabel.text = [NSString stringWithFormat:@"%@：%@",LocalString(@"eventhandsug"),sysLogModel.Suggest];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@",sysLogModel.Status];

}

- (IBAction)showOrHideAction:(UIButton *)sender {
    sender.selected = !sender.selected;
//    if (sender.selected) {
//        self.resolutionLabel.numberOfLines = 1;
//    } else {
//        self.resolutionLabel.numberOfLines = 0;
//    }
    self.sysLogModel.isShowAll = sender.selected;
    if (self.didShowAllBlock) {
        self.didShowAllBlock(sender.selected);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
