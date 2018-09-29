//
//  NSDictionary+TransformUntils.m
//  HuoSDKBox
//
//  Created by huosdk on 2016/11/8.
//  Copyright © 2016年 huosdk. All rights reserved.
//

#import "NSDictionary+TransformUntils.h"

@implementation NSDictionary (TransformUntils)


- (NSString *)toURLParamsString
{
    NSMutableString *paramsStr = [NSMutableString new];
    
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj && ![obj isEqualToString:@""]) {
            [paramsStr appendFormat:@"%@=%@&", key, [obj URLEncodedString]];
        }
        else
        {
            [paramsStr appendFormat:@"%@=%@&", key, @""];
        }
    }];
    
    [paramsStr deleteCharactersInRange:NSMakeRange([paramsStr length]-1, 1)];
    return paramsStr;
}

- (NSString *)toJsonString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        return jsonString;
    }
    else
        return @"";
    
}


@end
