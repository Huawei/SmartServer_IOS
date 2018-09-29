//
//  NSObject+CheckDataSure.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/3/13.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NSObject+CheckDataSure.h"

@implementation NSObject (CheckDataSure)

- (BOOL)isSureString {
    if (self && [self isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isSureDictionary {
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isSureArray {
    if (self && [self isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}
- (BOOL)isNoNull {
    if (self && ![self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (id)objectWitNoNull {
    if (self && ![self isKindOfClass:[NSNull class]]) {
        return self;
    }
    return @"";
}

- (id)objectWitNoNullWithNA {
    if (self && ![self isKindOfClass:[NSNull class]]) {
        return self;
    }
    return @"N/A";
}

@end
