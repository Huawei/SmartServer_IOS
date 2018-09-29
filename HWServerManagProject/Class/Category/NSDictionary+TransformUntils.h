//
//  NSDictionary+TransformUntils.h
//  HuoSDKBox
//
//  Created by huosdk on 2016/11/8.
//  Copyright © 2016年 huosdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+StringHelper.h"

@interface NSDictionary (TransformUntils)

- (NSString *)toURLParamsString;
- (NSString *)toJsonString;

@end
