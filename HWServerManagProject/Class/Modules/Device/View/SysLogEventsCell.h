//
//  HealthEventsCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysLogModel.h"

typedef void(^DidShowAllBlock)(BOOL isShowAll);

@interface SysLogEventsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *resolutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;
@property (copy, nonatomic) DidShowAllBlock didShowAllBlock;
@property (strong, nonatomic) SysLogModel *sysLogModel;

@end
