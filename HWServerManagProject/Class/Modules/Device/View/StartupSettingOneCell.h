//
//  StartupSettingOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartupSettingOneCell : UICollectionViewCell

@property (assign, nonatomic) BOOL isFirst;
@property (weak, nonatomic) UIViewController *controller;

@property (copy, nonatomic) NSString *bootSourceOverrideTarget;
@property (copy, nonatomic) NSString *bootSourceOverrideEnabled;

@property (copy, nonatomic) NSString *bootSourceOverrideMode;//UEFI、legacy

@property (assign, nonatomic) BOOL isSupportStartMode;


@end

/*
 None,
 Pxe,
 Floppy,
 Cd,
 Hdd,
 BiosSetup
 */
