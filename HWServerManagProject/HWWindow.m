//
//  HWWindow.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/19.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HWWindow.h"
#import "SafePwdInputViewController.h"
#import "AppDelegate.h"
#import "HWNavigationController.h"

@interface HWWindow ()

@property (nonatomic, assign) NSInteger idleTime;           //闲置时间
@property (nonatomic, assign) BOOL timeEnable;              //计时器是否可用
@property (nonatomic, strong) NSTimer *idleTimer;              //计时器是否可用


@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation HWWindow

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time = [date timeIntervalSince1970];
        self.lastTime = time;
    }
    return self;
}

- (void)sendEvent:(UIEvent *)event{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *localPwdLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
    if (localPwdLock != nil && localPwdLock.length == 6) {
        
        if (time - self.lastTime > 10 && !self.isShowPwd) {
            self.lastTime = time;
            [self showPwdInputAction];
            return;
        }
    }
    self.lastTime = time;
    
    
    [super sendEvent:event];
    
//    // 只在开始或结束触摸时 reset 闲置时间, 以减少不必须要的时钟 reset 动作
//    NSSet *allTouches = [event allTouches];
//
//    if (!self.isShowPwd) {
//        return;
//    }
//
//    if ([allTouches count] > 0) {
//        // allTouches.count 似乎只会是 1, 因此 anyObject 总是可用的
//        UITouchPhase phase =((UITouch *)[allTouches anyObject]).phase;
//        if (phase ==UITouchPhaseBegan || phase == UITouchPhaseEnded)
//            [self resetIdleTimer];
//    }
//
//    BLLog(@"111");
}

- (void)resetIdleTimer {
    if (self.timeEnable == YES && self.isShowPwd == YES) {
        [self stopIdleTiming];
        self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(idleTimerexecuted) userInfo:nil repeats:YES];
    }
}

- (void)idleTimerexecuted {
    self.idleTime += 1;
    if (self.idleTime == 180) {
        
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
        vc.isToInApp = YES;
        vc.isShowFingerprint = YES;
        [appdelegate.window.rootViewController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:NO completion:nil];
            BLLog(@"空闲180秒");
        [self setTimerEnable:NO];

    }
}

- (void)showPwdInputAction {
    self.isShowPwd = YES;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SafePwdInputViewController *vc = [[SafePwdInputViewController alloc] initWithNibName:@"SafePwdInputViewController" bundle:nil];
    vc.isToInApp = YES;
    vc.isShowFingerprint = YES;
    [appdelegate.window.rootViewController presentViewController:[[HWNavigationController alloc] initWithRootViewController:vc] animated:NO completion:nil];
    BLLog(@"空闲180秒");
//    [self setTimerEnable:NO];
}

- (void)stopIdleTiming{
    self.idleTime = 0;
    if (self.idleTimer) {
        [self.idleTimer invalidate];
        self.idleTimer = nil;
    }
}

- (void)setTimerEnable:(BOOL)enable{
    self.timeEnable = enable;
    self.isShowPwd = !enable;
//    NSString *localPwdLock = [[NSUserDefaults standardUserDefaults] objectForKey:PWD_LOCK_DATA];
//    if (localPwdLock != nil && localPwdLock.length == 6) {
//        self.isShowPwd = YES;
//    } else {
//        self.isShowPwd = NO;
//    }
//
//    if (!enable) {
//        [self stopIdleTiming];
//    }
//
//    [self resetIdleTimer];
}

@end
