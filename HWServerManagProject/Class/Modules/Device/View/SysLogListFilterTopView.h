//
//  GoodsListFilterTopView.h
//  market
//
//  Created by xunruiIOS on 2018/2/2.
//  Copyright © 2018年 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectSysTypeBlock)(NSInteger tabindex,NSString *value);
typedef void(^DidSelectSysTypeTimeBlock)(NSString *stime,NSString *etime);

@interface SysLogListFilterTopView : UIView

@property (strong, nonatomic) NSMutableArray *eventSubject;

@property (copy, nonatomic) DidSelectSysTypeBlock didSelectSysTypeBlock;
@property (copy, nonatomic) DidSelectSysTypeTimeBlock didSelectSysTypeTimeBlock;
@end
