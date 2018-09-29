//
//  NSString+StringHelper.h
//  SeaGameSDKDemo
//
//  Created by 谢京文 on 15/11/20.
//  Copyright © 2015年 SeaGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHelper)
//字符串进行md5加密
- (NSString *)getMD5Str;

//验证邮箱格式是否正确
- (BOOL)isRegularEmail;

- (BOOL)isRegularChinaPhone;

- (BOOL)isRegularEmailWithoutAlert;
//验证帐号格式是否正确
- (BOOL)isRegularUserName;
//验证密码格式是否正确
- (BOOL)isRegularPassword;

//将url的参数拼接字符串解析成字典
- (NSDictionary*)parseURL;
//urlencodedstring
- (NSString *)URLEncodedString;
//将1970的时间戳解析成年月日的格式
- (NSString *)timestrToTimeformat;
- (NSString *)testTimeString;
- (NSString *)time1970ToTimeformatymd;
//
- (NSString *)urlParamsToMD5;
- (NSData *)dataWithBase64Encoded;
- (NSString *) utf8ToUnicode;

- (NSString *)toMemoryBString;
- (NSString *)toCapacityString;

- (BOOL)isIpv6;


@end
