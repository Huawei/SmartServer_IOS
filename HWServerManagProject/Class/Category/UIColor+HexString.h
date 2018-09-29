//
//  UIColor+HexString.h
//  HuoGameBox
//
//  Created by xunruiIOS on 2017/10/23.
//  Copyright © 2017年 huosdk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
#pragma mark - 随机色
+ (UIColor *)randomColor;
@end
