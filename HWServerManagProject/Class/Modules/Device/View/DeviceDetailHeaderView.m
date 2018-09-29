//
//  DeviceDetailHeaderView.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceDetailHeaderView.h"
#import "DeviceDetailModelButton.h"

@implementation DeviceDetailHeaderView {
    NSArray *titleArray;
    NSArray *iconArray;
    NSArray *title1Array;
    NSArray *icon1Array;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ScreenWidth, 332);
    
    self.contentView.layer.shadowOpacity = 0.8;
    self.contentView.layer.shadowColor = RGBCOLOR(33, 40, 50).CGColor;
    self.contentView.layer.shadowRadius = 8;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    
//    titleArray = @[LocalString(@"devicedetailhealth"),LocalString(@"devicedetaillog"),LocalString(@"netset"),LocalString(@"devicedetailhardware"),LocalString(@"devicedetaildashboar"),LocalString(@"devicedetaillocation"),LocalString(@"devicedetailmeter"),LocalString(@"devicedetailmore")];
    titleArray = @[LocalString(@"currentwarming"),LocalString(@"devicedetailnetset"),LocalString(@"devicedetailhardware"),LocalString(@"devicedetaildashboar"),LocalString(@"devicedetaillocation"),LocalString(@"devicedetailmeter"),LocalString(@"devicedetailbootset"),LocalString(@"devicedetailmore")];
//    iconArray = @[@"one_devicedetailmodelicon0",
//                  @"one_devicedetailmodelicon1",
//                  @"one_devicedetailmodelicon2",
//                  @"one_devicedetailmodelicon3",
//                  @"one_devicedetailmodelicon4",
//                  @"one_devicedetailmodelicon5",
//                  @"one_devicedetailmodelicon6",
//                  @"one_devicedetailmodelicon100"];
    iconArray = @[@"one_devicedetailmodelicon0",
                  @"one_devicedetailmodelicon2",
                  @"one_devicedetailmodelicon3",
                  @"one_devicedetailmodelicon4",
                  @"one_devicedetailmodelicon5",
                  @"one_devicedetailmodelicon6",
                  @"one_devicedetailmodelicon7",
                  @"one_devicedetailmodelicon100"];
//    title1Array = @[LocalString(@"devicedetailhealth"),LocalString(@"devicedetaillog"),LocalString(@"netset"),LocalString(@"devicedetailhardware"),LocalString(@"devicedetaildashboar"),LocalString(@"devicedetaillocation"),LocalString(@"devicedetailmeter"),LocalString(@"devicedetailbootset"),LocalString(@"devicedetailcontrol"),LocalString(@"devicedetailuid"),LocalString(@"devicedetailfirmware"),LocalString(@"devicedetailreport"),LocalString(@"devicedetailcollection"),LocalString(@"devicedetailcollapse")];
    title1Array = @[LocalString(@"currentwarming"),LocalString(@"devicedetailnetset"),LocalString(@"devicedetailhardware"),LocalString(@"devicedetaildashboar"),LocalString(@"devicedetaillocation"),LocalString(@"devicedetailmeter"),LocalString(@"devicedetailbootset"),LocalString(@"devicedetailcontrol"),LocalString(@"devicedetailuid"),LocalString(@"devicedetailfirmware"),LocalString(@"devicedetailreport"),LocalString(@"devicedetailcollection"),LocalString(@"devicedetailcollapse")];

//    icon1Array = @[@"one_devicedetailmodelicon0",
//                  @"one_devicedetailmodelicon1",
//                  @"one_devicedetailmodelicon2",
//                  @"one_devicedetailmodelicon3",
//                  @"one_devicedetailmodelicon4",
//                  @"one_devicedetailmodelicon5",
//                  @"one_devicedetailmodelicon6",
//                  @"one_devicedetailmodelicon7",
//                  @"one_devicedetailmodelicon8",
//                  @"one_devicedetailmodelicon9",
//                   @"one_devicedetailmodelicon10",
//                   @"one_devicedetailmodelicon11",
//                   @"one_devicedetailmodelicon12",
//                  @"one_devicedetailmodelicon101"];
    icon1Array = @[@"one_devicedetailmodelicon0",
                   @"one_devicedetailmodelicon2",
                   @"one_devicedetailmodelicon3",
                   @"one_devicedetailmodelicon4",
                   @"one_devicedetailmodelicon5",
                   @"one_devicedetailmodelicon6",
                   @"one_devicedetailmodelicon7",
                   @"one_devicedetailmodelicon8",
                   @"one_devicedetailmodelicon9",
                   @"one_devicedetailmodelicon10",
                   @"one_devicedetailmodelicon11",
                   @"one_devicedetailmodelicon12",
                   @"one_devicedetailmodelicon101"];

    [self setUpUI];
}

- (void)setUpUI {
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[DeviceDetailModelButton class]]) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat tempspace = 0;
    CGFloat tempy = 114;
    CGFloat tempx = tempspace;
    for (int i = 0 ; i< titleArray.count; i++) {
        DeviceDetailModelButton *btn = [[[NSBundle mainBundle] loadNibNamed:@"DeviceDetailModelButton" owner:nil options:nil] lastObject];
        btn.iconIMV.image = [UIImage imageNamed:iconArray[i]];
        btn.titleLabel.text = titleArray[i];
        btn.frame = CGRectMake(tempx + (ScreenWidth/4+tempspace)*(i%4), tempy + 71*(i/4), ScreenWidth/4, 60);
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == titleArray.count-1) {
            btn.tag = 100;
        }
    }
    self.frame = CGRectMake(0, 0, ScreenWidth, 272);
    if (self.didChangeFrameBlock) {
        self.didChangeFrameBlock();
    }
}

- (void)setUpUITwo {
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[DeviceDetailModelButton class]]) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat tempspace = 0;
    CGFloat tempy = 114;
    CGFloat tempx = tempspace;
    for (int i = 0 ; i< title1Array.count; i++) {
        DeviceDetailModelButton *btn = [[[NSBundle mainBundle] loadNibNamed:@"DeviceDetailModelButton" owner:nil options:nil] lastObject];
        btn.iconIMV.image = [UIImage imageNamed:icon1Array[i]];
        btn.titleLabel.text = title1Array[i];
        btn.frame = CGRectMake(tempx + (ScreenWidth/4+tempspace)*(i%4), tempy + 71*(i/4), ScreenWidth/4, 60);
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == title1Array.count-1) {
            btn.tag = 101;
        }
    }
    self.frame = CGRectMake(0, 0, ScreenWidth, 392);
    if (self.didChangeFrameBlock) {
        self.didChangeFrameBlock();
    }

}

- (IBAction)didClickAction:(UIView *)sender {
    
    if (sender.tag == 100) {
        [self setUpUITwo];
        return;
    } else if (sender.tag == 101) {
        [self setUpUI];
        return;
    }
    if (self.didItemBlock) {
        self.didItemBlock(sender.tag);
    }
}

- (IBAction)toHealthAction:(id)sender {
    if (self.didToHealthBlock) {
        self.didToHealthBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
