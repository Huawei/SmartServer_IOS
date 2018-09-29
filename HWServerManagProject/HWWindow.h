//
//  HWWindow.h
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWWindow : UIWindow

@property (nonatomic, assign) BOOL isShowPwd;


/*!
 *  计时器是否可用（处在手势密码页时不可用）
 */
- (void)setTimerEnable:(BOOL)enable;

- (void)showPwdInputAction;

/*!
 *  停止闲置计时
 */
- (void)stopIdleTiming;

/*!
 *  重新开始闲置计时
 */
- (void)resetIdleTimer;

@end
