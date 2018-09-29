//
//  TYNetWorking.m
//  WallPaperIPhone
//
//  Created by xunruiIOS on 2017/11/8.
//  Copyright © 2017年 czx. All rights reserved.
//

#import "TYNetWorking.h"
#import "AFNetworking.h"
#import "HWNavigationController.h"
#import "RefreshLogManager.h"


@interface TYNetWorking()
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@end

@implementation TYNetWorking

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
//        securityPolicy.validatesDomainName = YES;
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        self.manager.securityPolicy  = securityPolicy;
        
       
        
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //响应结果序列化类型
        [self.manager.requestSerializer setTimeoutInterval:15];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/json",@"text/html",@"application/json", @"text/javascript",  nil];
//        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html" ,nil];
        
        
    }
    return self;
}

+ (TYNetWorking *)defaultClient {
    static TYNetWorking *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)deleteWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    if ([HWGlobalData shared].XAuthToken) {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].XAuthToken forHTTPHeaderField:@"X-Auth-Token"];
    } else {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:@"" forHTTPHeaderField:@"X-Auth-Token"];
        
    }
    [[TYNetWorking defaultClient].manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        successBlock(data);
        BLLog(@"params:%@---result:%@",parameters,responseObject);
        [HWGlobalData shared].XAuthToken = @"";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HWGlobalData shared].XAuthToken = @"";
        failureBlock(error);
        BLLog(@"params:%@---result:%@",parameters,[TYNetWorking stringForError:error]);
    }];
}

+ (void)getImageWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    
    [[TYNetWorking defaultClient].manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        successBlock(data);
        BLLog(@"params:%@---result:%@",parameters,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    if ([HWGlobalData shared].XAuthToken.length > 0) {
        @synchronized(self) {
            [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].XAuthToken forHTTPHeaderField:@"X-Auth-Token"];
        }
        
      
        
    } else {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:@"" forHTTPHeaderField:@"X-Auth-Token"];
        
    }
    [[TYNetWorking defaultClient].manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *ETag = allHeaders[@"ETag"];
        [HWGlobalData shared].ETag = ETag;
        
        NSDictionary *data = responseObject;

        [RefreshLogManager writeLog:@"successfully" withRedfish:url];
        successBlock(data);

        BLLog(@"params:%@---result:%@",parameters,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (error.code == -1001 || error.code == -1009) {
            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"netnoalert") duration:2.5 position:CSToastPositionCenter];
        }
        NSString *errresult = [TYNetWorking stringForError:error];
        [RefreshLogManager writeLog:[NSString stringWithFormat:@"%@",errresult] withRedfish:url];
        BLLog(@"url:---%@,params:%@---result:%@",url,parameters,errresult);
        NSDictionary *dic = [self dicForError:error];
        if (dic.isSureDictionary) {
            NSDictionary *dic2 = dic[@"error"];
            if (dic2 && [dic2 isKindOfClass:[NSDictionary class]]) {
                NSArray *temparr = dic2[@"@Message.ExtendedInfo"];
                if (temparr.isSureArray && temparr.count > 0) {
                    NSDictionary *tempdic = [temparr firstObject];
                    if (tempdic.isSureDictionary) {
                        NSString *messid = tempdic[@"MessageId"];
                        if (messid.isSureString && [messid hasSuffix:@"SessionLimitExceeded"]) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"SessionLimitExceededError") preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                UIViewController *vc =[TYNetWorking getCurrentVC];
                                [vc.navigationController popToRootViewControllerAnimated:YES];
                            }]];
                            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                            [vc presentViewController:alert animated:YES completion:nil];
                        } else if (messid.isSureString && [messid hasSuffix:@"LoginFailed"]) {
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"loginError") preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                UIViewController *vc =[TYNetWorking getCurrentVC];
                                [vc.navigationController popToRootViewControllerAnimated:YES];
                            }]];
                            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                            [vc presentViewController:alert animated:YES completion:nil];
                            
                        } else {
                            NSArray *temparr3 = [messid componentsSeparatedByString:@"."];
                            if (temparr3.count > 0) {
                                NSString *tempstr111 = [temparr3 lastObject];
                                if ([tempstr111 isEqualToString:@"NoValidSession"]) {
                                    DeviceModel *model = [HWGlobalData shared].curDevice;
                                    if (model == nil) {
                                        failureBlock(error);
                                        return ;
                                    }
                                    [ABNetWorking deleteWithSessionService:^{
                                        [HWGlobalData shared].curDevice = model;
                                        [ABNetWorking postWithUrlWithAction:@"redfish/v1/SessionService/Sessions" parameters:@{@"UserName":[HWGlobalData shared].curDevice.account,@"Password":[HWGlobalData shared].curDevice.password} success:^(NSDictionary *result) {
                                            [HWGlobalData shared].session_id = result[@"Id"];
                                            [weakSelf getWithUrlString:url parameters:parameters success:successBlock failure:failureBlock];
                                        } failure:^(NSError *error) {
                                            failureBlock(error);
                                        }];
                                    }];
                                    
                                    BLLog(@"-------------------------------超时");
                                    return ;
                                }
                                
                                NSArray *messageArrgs = tempdic[@"MessageArgs"];
                                if (messageArrgs.isSureArray && messageArrgs.count > 0) {
                                    NSString *messagearrfirst = messageArrgs.firstObject;
                                    if ([messagearrfirst hasSuffix:@"MemoryView"]) {
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"operationfail") message:LocalString(@"memoryviewneedupgrade") preferredStyle:UIAlertControllerStyleAlert];
                                        [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:nil]];
                                        UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                                        [vc presentViewController:alert animated:YES completion:nil];
                                        failureBlock(error);
                                        return;

                                    }
                                }
                                [[UIApplication sharedApplication].delegate.window makeToast:[temparr3 lastObject]];

                            }
                        }
                    }
                }
                
                
            }
        }
        failureBlock(error);
    }];
}

+ (void)get2WithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    if ([HWGlobalData shared].XAuthToken.length > 0) {
        @synchronized(self) {
            [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].XAuthToken forHTTPHeaderField:@"X-Auth-Token"];
        }
        
    } else {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:@"" forHTTPHeaderField:@"X-Auth-Token"];
        
    }
    [[TYNetWorking defaultClient].manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *ETag = allHeaders[@"ETag"];
        [HWGlobalData shared].ETag = ETag;
        
        NSDictionary *data = responseObject;
        
        [RefreshLogManager writeLog:@"successfully" withRedfish:url];
        successBlock(data);
        
        BLLog(@"params:%@---result:%@",parameters,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);

        NSString *errresult = [TYNetWorking stringForError:error];
        [RefreshLogManager writeLog:[NSString stringWithFormat:@"%@",errresult] withRedfish:url];
  
    }];
}

+ (void)patchWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    __weak typeof(self) weakSelf = self;
    if ([HWGlobalData shared].ETag) {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].ETag forHTTPHeaderField:@"If-Match"];
    } else {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:@"" forHTTPHeaderField:@"If-Match"];
    }
    if ([HWGlobalData shared].XAuthToken.length > 0) {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].XAuthToken forHTTPHeaderField:@"X-Auth-Token"];
    } else {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:@"" forHTTPHeaderField:@"X-Auth-Token"];
    }
    
    [[TYNetWorking defaultClient].manager PATCH:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        [RefreshLogManager writeLog:@"successfully" withRedfish:url];
        successBlock(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
        
        NSDictionary *userinfo = error.userInfo;
        if (userinfo) {
            NSHTTPURLResponse *response = userinfo[@"com.alamofire.serialization.response.error.response"];
            
            if (response.statusCode == 501) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"operationfail") message:LocalString(@"operationfailalert501str") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                [vc presentViewController:alert animated:YES completion:nil];
                
                return ;
            }
        }
        NSString *errresult = [TYNetWorking stringForError:error];
        [RefreshLogManager writeLog:[NSString stringWithFormat:@"%@",errresult] withRedfish:url];
        BLLog(@"params:%@---result:%@",parameters,errresult);
        if (error.code == -1001 || error.code == -1009) {
//            [[UIApplication sharedApplication].delegate.window makeToast:LocalString(@"netnoalert") duration:2.5 position:CSToastPositionCenter];
//            UIViewController *vc =[TYNetWorking getCurrentVC];
//            [vc.navigationController popToRootViewControllerAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"requesttimeout") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIViewController *vc =[TYNetWorking getCurrentVC];
                [vc.navigationController popToRootViewControllerAnimated:YES];
            }]];
            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
            [vc presentViewController:alert animated:YES completion:nil];
            return;
        }
        NSDictionary *dic = [self dicForError:error];
        if (dic.isSureDictionary) {
            NSDictionary *dic2 = dic[@"error"];
            if (dic2 && [dic2 isKindOfClass:[NSDictionary class]]) {
                NSArray *temparr = dic2[@"@Message.ExtendedInfo"];
                if (temparr.isSureArray && temparr.count > 0) {
                    NSDictionary *tempdic = [temparr firstObject];
                    if (tempdic.isSureDictionary) {
                        NSString *messid = tempdic[@"MessageId"];
                        if (messid.isSureString && [messid hasSuffix:@"SessionLimitExceeded"]) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"SessionLimitExceededError") preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                UIViewController *vc =[TYNetWorking getCurrentVC];
                                [vc.navigationController popToRootViewControllerAnimated:YES];
                            }]];
                            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                            [vc presentViewController:alert animated:YES completion:nil];
                        } else if (messid.isSureString && [messid hasSuffix:@"LoginFailed"]) {
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"loginError") preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                UIViewController *vc =[TYNetWorking getCurrentVC];
                                [vc.navigationController popToRootViewControllerAnimated:YES];
                            }]];
                            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                            [vc presentViewController:alert animated:YES completion:nil];
                            
                        } else {
                            NSArray *temparr3 = [messid componentsSeparatedByString:@"."];
                            if (temparr3.count > 0) {
                                NSString *tempstr111 = [temparr3 lastObject];
                                if ([tempstr111 isEqualToString:@"NoValidSession"]) {
                                    DeviceModel *model = [HWGlobalData shared].curDevice;
                                    if (model == nil) {
                                        failureBlock(error);
                                        return ;
                                    }
                                    [ABNetWorking deleteWithSessionService:^{
                                        [HWGlobalData shared].curDevice = model;
                                        [ABNetWorking postWithUrlWithAction:@"redfish/v1/SessionService/Sessions" parameters:@{@"UserName":[HWGlobalData shared].curDevice.account,@"Password":[HWGlobalData shared].curDevice.password} success:^(NSDictionary *result) {
                                            [HWGlobalData shared].session_id = result[@"Id"];
                                            [weakSelf patchWithUrlString:url parameters:parameters success:successBlock failure:failureBlock];
                                        } failure:nil];
                                    }];
                                    
                                    BLLog(@"-------------------------------超时");
                                    return ;
                                }
                                [[UIApplication sharedApplication].delegate.window makeToast:[temparr3 lastObject]];
                            }
                        }
                    }
                }
                
                
            }
        }
    }];
}
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    
//    if ([HWGlobalData shared].XAuthToken) {
        [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].XAuthToken forHTTPHeaderField:@"X-Auth-Token"];
//    } else {
//        [[TYNetWorking defaultClient].manager.requestSerializer setValue:@"" forHTTPHeaderField:@"X-Auth-Token"];
//    }
    
    __weak typeof(self) weakSelf = self;
    [[TYNetWorking defaultClient].manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *location = allHeaders[@"Location"];
        if (location) {
            if ([location hasPrefix:@"/redfish/v1/SessionService/Sessions/"]) {
                [HWGlobalData shared].XAuthToken = [allHeaders[@"X-Auth-Token"] mutableCopy];
            }
        }
        BLLog(@"%@",allHeaders);
        [RefreshLogManager writeLog:@"successfully" withRedfish:url];
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errresult = [TYNetWorking stringForError:error];
        [RefreshLogManager writeLog:[NSString stringWithFormat:@"%@",errresult] withRedfish:url];
        BLLog(@"url:---%@,params:%@---result:%@",url,parameters,errresult);

        if (error.code == -1001 || error.code == -1004 || error.code == -1009 || error.code == -1200) {

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"requesttimeout") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIViewController *vc =[TYNetWorking getCurrentVC];
                [vc.navigationController popToRootViewControllerAnimated:YES];
            }]];
            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
            [vc presentViewController:alert animated:YES completion:nil];
            
            failureBlock(nil);
            return ;
        }
        NSDictionary *dic = [self dicForError:error];
        if (dic.isSureDictionary) {
            NSDictionary *dic2 = dic[@"error"];
            if (dic2 && [dic2 isKindOfClass:[NSDictionary class]]) {
                NSArray *temparr = dic2[@"@Message.ExtendedInfo"];
                if (temparr.isSureArray && temparr.count > 0) {
                    NSDictionary *tempdic = [temparr firstObject];
                    if (tempdic.isSureDictionary) {
                        NSString *messid = tempdic[@"MessageId"];
                        if (messid.isSureString && [messid hasSuffix:@"SessionLimitExceeded"]) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"SessionLimitExceededError") preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                UIViewController *vc =[TYNetWorking getCurrentVC];
                                [vc.navigationController popToRootViewControllerAnimated:YES];
                            }]];
                            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                            [vc presentViewController:alert animated:YES completion:nil];
                            failureBlock(nil);
                            return;
                        } else if (messid.isSureString && [messid hasSuffix:@"LoginFailed"]) {
                           
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"renzhengshibai") message:LocalString(@"loginError") preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                UIViewController *vc =[TYNetWorking getCurrentVC];
                                [vc.navigationController popToRootViewControllerAnimated:YES];
                            }]];
                            UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                            [vc presentViewController:alert animated:YES completion:nil];
                            failureBlock(nil);
                            return;
                        } else {
                            NSArray *temparr3 = [messid componentsSeparatedByString:@"."];
                            if (temparr3.count > 0) {
                                
                                NSString *tempstr111 = [temparr3 lastObject];
                                if ([tempstr111 isEqualToString:@"NoValidSession"]) {
                                    DeviceModel *model = [HWGlobalData shared].curDevice;
                                    if (model == nil) {
                                        failureBlock(error);
                                        return ;
                                    }
                                    [ABNetWorking deleteWithSessionService:^{
                                        [HWGlobalData shared].curDevice = model;                                        [ABNetWorking postWithUrlWithAction:@"redfish/v1/SessionService/Sessions" parameters:@{@"UserName":[HWGlobalData shared].curDevice.account,@"Password":[HWGlobalData shared].curDevice.password} success:^(NSDictionary *result) {
                                            [HWGlobalData shared].session_id = result[@"Id"];
                                            [weakSelf postWithUrlString:url parameters:parameters success:successBlock failure:failureBlock];
                                        } failure:^(NSError *error) {
                                            failureBlock(error);
                                        }];
                                    }];
                                    
                                    BLLog(@"-------------------------------超时");
                                    return ;
                                }
                                
                                [[UIApplication sharedApplication].delegate.window makeToast:[temparr3 lastObject]];
                            }
                        }
                    }
                }
            }
        }
        
        failureBlock(error);
    }];
}

+ (void)post2WithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    
    [[TYNetWorking defaultClient].manager.requestSerializer setValue:[HWGlobalData shared].XAuthToken forHTTPHeaderField:@"X-Auth-Token"];
    __weak typeof(self) weakSelf = self;
    [[TYNetWorking defaultClient].manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *location = allHeaders[@"Location"];
        if (location) {
            if ([location hasPrefix:@"/redfish/v1/SessionService/Sessions/"]) {
                [HWGlobalData shared].XAuthToken = [allHeaders[@"X-Auth-Token"] mutableCopy];
            }
        }
        BLLog(@"%@",allHeaders);
        [RefreshLogManager writeLog:@"successfully" withRedfish:url];
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errresult = [TYNetWorking stringForError:error];
        [RefreshLogManager writeLog:[NSString stringWithFormat:@"%@",errresult] withRedfish:url];
        BLLog(@"params:%@---result:%@",parameters,errresult);
        
        failureBlock(error);
    }];
}


+ (NSString *)stringForError:(NSError *)error {
    
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    if (data == nil) {
        NSString *str = error.userInfo[@"NSUnderlyingError"];
        return str;
    }
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSDictionary *)dicForError:(NSError *)error {
    
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    if (data == nil) {
//        NSString *str = error.userInfo[@"NSUnderlyingError"];
        return nil;
    }
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return jsonDict;
}

+ (NSString *)parseParams:(NSDictionary *)param {
    NSMutableString *string = [NSMutableString string];
    //便利字典把键值平起来
    [param enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@",obj];
        [string appendFormat:@"%@",@"&"];
    }];
    NSRange rangeLast = [string rangeOfString:@"&"options:NSBackwardsSearch];
    if (rangeLast.length !=0) {
        [string deleteCharactersInRange:rangeLast];
    }
    NSRange range =NSMakeRange(0, [string length]);
    [string replaceOccurrencesOfString:@":" withString:@"=" options:NSCaseInsensitiveSearch range:range];
    
    return string;
}


+ (void)uploadImagesToServer:(NSString *)strUrl dicPostParams:(NSMutableDictionary *)parameters imageArray:(NSArray *) imageArray fileName:(NSArray *)fileNameArray imageName:(NSArray *)imageNameArray imageSizeMB:(float)sizeMB Success :(SuccessBlock)success andFailure:(FailureBlock)failure {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //分界线的标识符
        NSString *customBoundary = @"tyczx";
        NSURL *url = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //分界线 --tyczx
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",customBoundary];
        //结束符 tyczx--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //要上传的图片

        UIImage *image = nil;
        
        //将要上传的图片压缩 并赋值与上传的Data数组
        NSMutableArray *imageDataArray = [NSMutableArray array];
        for (int i = 0; i<imageArray.count; i++) {
            //要上传的图片
            image= imageArray[i];
//            /**************  将图片压缩成我们需要的数据包大小 *******************/
            NSData * data = UIImageJPEGRepresentation(image, 0.5);
            CGFloat dataKBytes = data.length/1000.0;
            CGFloat maxQuality = 0.9f;
            CGFloat lastData = dataKBytes;
            while (dataKBytes > 1024*sizeMB && maxQuality > 0.01f) {
                //将图片压缩成(sizeMB)M
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 1000.0;
                if (lastData == dataKBytes) {
                    break;
                }else{
                    lastData = dataKBytes;
                }
            }
//            /**************  将图片压缩成我们需要的数据包大小 *******************/
            [imageDataArray addObject:data];
        }
        
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [parameters allKeys];
        //遍历keys
        for(int i=0;i<[keys count];i++) {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
        
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //循环加入上传图片
        for(int i = 0; i< [imageDataArray count] ; i++){
            //要上传的图片
            //得到图片的data
            NSData* data =  imageDataArray[i];
            NSMutableString *imgbody = [[NSMutableString alloc] init];
            //此处循环添加图片文件
            //添加图片信息字段
            ////添加分界线，换行
            [imgbody appendFormat:@"%@\r\n",MPboundary];
            [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", fileNameArray[i],imageNameArray[i]];
            //声明上传文件的格式
//            [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
            [imgbody appendFormat:@"Content-Type: image/jpeg; charset=utf-8\r\n\r\n"];

            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //声明结束符：--tyczx--
        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
        //加入结束符--tyczx--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",customBoundary];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    failure(error);
                }
                else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    success(dic);
                    
                }
            });
            
        }];
        [sessionDataTask resume];
    });
}

//获取当前屏幕显示的viewcontroller

+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[HWNavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
    
}
@end
