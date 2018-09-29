//
//  DeviceDetailHeaderView.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidItemBlock)(NSInteger itemRow);
typedef void(^DidChangeFrameBlock)(void);
typedef void(^DidToHealthBlock)(void);

@interface DeviceDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIImageView *powerStateIMV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (copy, nonatomic) DidItemBlock didItemBlock;
@property (copy, nonatomic) DidChangeFrameBlock didChangeFrameBlock;
@property (copy, nonatomic) DidToHealthBlock didToHealthBlock;



@end
