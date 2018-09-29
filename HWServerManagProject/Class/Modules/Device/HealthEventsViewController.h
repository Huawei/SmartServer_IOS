//
//  HealthEventsViewController.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWBaseViewController.h"

typedef void(^DidRefreshBlock)(void);

@interface HealthEventsViewController : HWBaseViewController

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) DidRefreshBlock didRefreshBlock;

//@property (assign, nonatomic) NSInteger severity;//1OK、2Warning、 3Critical

@end
