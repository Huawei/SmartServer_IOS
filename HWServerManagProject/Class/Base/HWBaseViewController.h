//
//  WPBaseViewController.h
//  WallPaperIPhone
//
//  Created by xunruiIOS on 2017/8/29.
//  Copyright © 2017年 czx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWBaseViewController : UIViewController

@property (strong, nonatomic) UIView *customNavView;
@property (strong, nonatomic) UIView *customNavBgView;
@property (copy, nonatomic) NSString *customTitle;

@property (assign, nonatomic) NSInteger requestPageIndex;

@end
