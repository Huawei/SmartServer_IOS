//
//  ABNetWorking.m
//  appbox
//
//  Created by xunruiIOS on 2017/12/8.
//  Copyright © 2017年 陈主祥. All rights reserved.
//

#import "ABNetWorking.h"

@implementation ABNetWorking


+ (void)deleteWithSessionService:(void (^)(void))completeBlock {
    if ([HWGlobalData shared].XAuthToken.length > 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *urlstring = [NSString stringWithFormat:@"%@:%@/redfish/v1/SessionService/Sessions/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,[HWGlobalData shared].session_id];
            if (![urlstring hasPrefix:@"http"]) {
                urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
            }
            [TYNetWorking deleteWithUrlString:urlstring parameters:nil success:^(NSDictionary *result) {
                
                [HWGlobalData shared].XAuthToken = @"";
                [HWGlobalData shared].curDevice = nil;
                [HWGlobalData shared].session_id = nil;
                completeBlock();
            } failure:^(NSError *error) {
                
                [HWGlobalData shared].curDevice = nil;
                [HWGlobalData shared].session_id = nil;
                [HWGlobalData shared].XAuthToken = @"";
                completeBlock();
            }];
            
        });
    } else {
       
        [HWGlobalData shared].curDevice = nil;
        [HWGlobalData shared].session_id = nil;
        [HWGlobalData shared].XAuthToken = @"";
        completeBlock();
    }
}

+ (void)deleteWithSessionService:(NSString *)session_id port:(NSString *)port deviceName:(NSString *)deviceName block:(void (^)(void))completeBlock {
    if ([HWGlobalData shared].XAuthToken.length > 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *urlstring = [NSString stringWithFormat:@"%@:%@/redfish/v1/SessionService/Sessions/%@",deviceName,port,session_id];
            if (![urlstring hasPrefix:@"http"]) {
                urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
            }
            [TYNetWorking deleteWithUrlString:urlstring parameters:nil success:^(NSDictionary *result) {
                [HWGlobalData shared].XAuthToken = @"";
                [HWGlobalData shared].curDevice = nil;
                [HWGlobalData shared].session_id = nil;
                completeBlock();
            } failure:^(NSError *error) {
                [HWGlobalData shared].XAuthToken = @"";
                [HWGlobalData shared].curDevice = nil;
                [HWGlobalData shared].session_id = nil;
                completeBlock();
            }];
            
        });
    } else {
        completeBlock();
    }
}
    
+ (void)postWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlstring = [NSString stringWithFormat:@"%@:%@/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,action];
        if (![urlstring hasPrefix:@"http"]) {
            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
        }
        [TYNetWorking postWithUrlString:urlstring parameters:parameters success:^(NSDictionary *result) {
            successBlock(result);
            
        } failure:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
//            failureBlock(error);
        }];
        
    });
}


+ (void)addPostWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlstring = [NSString stringWithFormat:@"%@:%@/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,action];
        if (![urlstring hasPrefix:@"http"]) {
            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
        }
        [TYNetWorking post2WithUrlString:urlstring parameters:parameters success:^(NSDictionary *result) {
            successBlock(result);
            
        } failure:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
            //            failureBlock(error);
        }];
        
    });
}


+ (void)patchWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstring = [NSString stringWithFormat:@"%@:%@/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,action];
        if (![urlstring hasPrefix:@"http"]) {
            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
        }
        [TYNetWorking patchWithUrlString:urlstring parameters:parameters success:^(NSDictionary *result) {
            
            successBlock(result);
            
        } failure:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
            
        }];
        
    });
}


+ (void)getWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    if (parameters == nil) {
        parameters = @{};
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstring = [NSString stringWithFormat:@"%@:%@/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,action];
        if (![urlstring hasPrefix:@"http"]) {
            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
        }
        
        [TYNetWorking getWithUrlString:urlstring parameters:parameters success:^(NSDictionary *result) {
            
            successBlock(result);
            
        } failure:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
            
        }];
        
    });
}



+ (void)addGetWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    if (parameters == nil) {
        parameters = @{};
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstring = [NSString stringWithFormat:@"%@:%@/%@",[HWGlobalData shared].curDevice.deviceName,[HWGlobalData shared].curDevice.port,action];
        if (![urlstring hasPrefix:@"http"]) {
            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
        }
        
        [TYNetWorking get2WithUrlString:urlstring parameters:parameters success:^(NSDictionary *result) {
            
            successBlock(result);
            
        } failure:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
            
        }];
        
    });
}


+ (void)getImageSuccess:(void (^)(NSString * _Nullable))success {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstring = [NSString stringWithFormat:@"%@/",[HWGlobalData shared].curDevice.deviceName];
        if (![urlstring hasPrefix:@"http"]) {
            urlstring = [NSString stringWithFormat:@"https://%@",urlstring];
        }
        [TYNetWorking getImageWithUrlString:urlstring parameters:nil success:^(NSDictionary *result) {
            
            success(@"");
            
        } failure:^(NSError *error) {
            
            NSString *resultstr = [TYNetWorking stringForError:error];
            
            NSArray *arr = [self filterImage:resultstr];
            if (arr.count > 0) {
                success([arr lastObject]);
            } else {
                success(@"");
            }
        }];
        
    });
}


+ (NSArray *)filterImage:(NSString *)html
{
    if (html == nil || ![html isKindOfClass:[NSString class]]) {
        return @[];
    }
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img(.*?)>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
}



@end
