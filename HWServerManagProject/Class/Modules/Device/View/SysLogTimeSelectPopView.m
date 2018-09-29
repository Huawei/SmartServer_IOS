//
//  DeviceDetailChangePopView.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "SysLogTimeSelectPopView.h"
#import "PopTabeleCell.h"

@interface SysLogTimeSelectPopView()

@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation SysLogTimeSelectPopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    self.title1Label.text = LocalString(@"system_log_date_range_from");
    self.title2Label.text = LocalString(@"system_log_date_range_to");
    [self.cancelBtn setTitle:LocalString(@"cancel") forState:UIControlStateNormal];
    [self.sureBtn setTitle:LocalString(@"sure") forState:UIControlStateNormal];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
}

- (IBAction)didSureAction:(id)sender {
    
    
    if (self.didSelectSysLogTimeBlock) {
        NSDate *startDate = self.startPicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *sDateString = [dateFormatter stringFromDate:startDate];
        
        NSDate *endDate = self.endPicker.date;
        NSString *eDateString = [dateFormatter stringFromDate:endDate];
        
        self.didSelectSysLogTimeBlock(sDateString, eDateString);
        
    }
    
    [self removeFromSuperview];
}

- (IBAction)didCancelAction:(id)sender {
    [self removeFromSuperview];
}


@end
