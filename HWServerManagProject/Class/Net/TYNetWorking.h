//
//  TYNetWorking.h
//  WallPaperIPhone
//
//  Created by xunruiIOS on 2017/11/8.
//  Copyright © 2017年 czx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^SuccessBlock)(NSDictionary *result);
typedef void (^FailureBlock)(NSError *error);

@interface TYNetWorking : NSObject

/**
 *  delete请求
 */
+ (void)deleteWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  get请求
 */
+ (void)getImageWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)get2WithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)patchWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)post2WithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 * 上传图片
 */
+(void)uploadImagesToServer:(NSString *)strUrl dicPostParams:(NSMutableDictionary *)parameters imageArray:(NSArray *) imageArray fileName:(NSArray *)fileNameArray imageName:(NSArray *)imageNameArray imageSizeMB:(float)sizeMB Success :(SuccessBlock)success andFailure:(FailureBlock)failure;

+ (NSString *)stringForError:(NSError *)error;

@end
