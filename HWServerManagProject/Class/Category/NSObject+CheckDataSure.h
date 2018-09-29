//
//  NSObject+CheckDataSure.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/3/13.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CheckDataSure)

- (BOOL)isSureString;
- (BOOL)isSureDictionary;
- (BOOL)isSureArray;
- (BOOL)isNoNull;

- (id)objectWitNoNull;
- (id)objectWitNoNullWithNA;

@end
