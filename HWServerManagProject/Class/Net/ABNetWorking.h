//
//  ABNetWorking.h
//  appbox
//
//  Created by xunruiIOS on 2017/12/8.
//  Copyright © 2017年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYNetWorking.h"

@interface ABNetWorking : NSObject<NSURLSessionDelegate>

///**
// *  get请求
// */
//+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)patchWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)deleteWithSessionService:(void (^)(void))completeBlock;
+ (void)deleteWithSessionService:(NSString *)session_id port:(NSString *)port deviceName:(NSString *)deviceName block:(void (^)(void))completeBlock;
/**
 * post请求
 */
+ (void)postWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)addPostWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)getWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock ;
+ (void)addGetWithUrlWithAction:(NSString *)action parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock ;

+ (void)getImageSuccess:(void (^_Nullable)(NSString *imageurlstr))success;



//+ (void)postWithDeviceAndeUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


//+ (NSString *)getUserAgent;//启动获取

@end
