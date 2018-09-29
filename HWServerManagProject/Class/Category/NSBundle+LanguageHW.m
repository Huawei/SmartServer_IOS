//
//  NSBundle+LanguageHW.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/7/26.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NSBundle+LanguageHW.h"
#import <objc/message.h>

@implementation NSBundle (LanguageHW)

+ (void)load {
    
    Method imageNamedMethod = class_getClassMethod(self, @selector(mj_localizedStringForKey:value:));
    // 获取xmg_imageNamed
    Method xmg_imageNamedMethod = class_getClassMethod(self, @selector(hw_localizedStringForKey:value:));
    
    // 交互方法:runtime
    method_exchangeImplementations(imageNamedMethod, xmg_imageNamedMethod);
    // 调用imageNamed => xmg_imageNamedMethod
    // 调用xmg_imageNamedMethod => imageNamed
}

+ (NSString *)hw_localizedStringForKey:(NSString *)key value:(NSString *)value {

    return [[NSBundle bundleWithPath:[[NSBundle mj_refreshBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil];
}
@end
