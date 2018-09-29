//
//  CustomZXTitleView.m
//  AntShare
//
//  Created by 陈主祥 on 2017/12/2.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "CustomZXTitleView.h"

@implementation CustomZXTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        if (@available(iOS 11.0, *)) {
//            self.translatesAutoresizingMaskIntoConstraints = false;
//        } else {
//        }

    }
    return self;
}

- (CGSize)intrinsicContentSize {
//    if (@available(iOS 11.0, *)) {
            return UILayoutFittingExpandedSize;
//    } else {
//        return CGSizeMake(SCREEN_WIDTH - 120, 44);
//    }

}

//- (void)setFrame:(CGRect)frame {
//    if (@available(iOS 11.0, *)) {
//        [super setFrame:frame];
//    } else {
//        [super setFrame:CGRectMake(8, 0, SCREENWIDTH-16, self.superview.bounds.size.height)];
//        //跟iOS11一样尺寸
//    }
//}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    if (@available(iOS 11.0, *)) {
//        self.center = CGPointMake(SCREEN_WIDTH/2-50, self.center.y);
////
//    } else {
//    }
//}
@end
