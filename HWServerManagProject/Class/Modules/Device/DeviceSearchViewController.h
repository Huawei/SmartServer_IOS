//
//  DeviceSearchViewController.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWBaseViewController.h"

typedef void(^DidSelectWordBlock)(NSString *word);

@interface DeviceSearchViewController : HWBaseViewController

@property (nonatomic, weak) UIView *topBgView;

//@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *wordArray;
@property (copy, nonatomic) DidSelectWordBlock didSelectWordBlock;

@end
