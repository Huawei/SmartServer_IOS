//
//  RefreshLogManager.h
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/21.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshLogManager : NSObject

+ (NSString *)getToDayLogPath;
+ (void)writeLog:(NSString *)log withRedfish:(NSString *)uri;
+ (void)deletefileGiveUpLog;
@end
