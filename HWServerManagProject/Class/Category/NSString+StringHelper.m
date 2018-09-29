//
//  NSString+StringHelper.m
//  SeaGameSDKDemo
//
//  Created by 谢京文 on 15/11/20.
//  Copyright © 2015年 SeaGame. All rights reserved.
//

#import "NSString+StringHelper.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (StringHelper)

- (NSString *)getMD5Str
{
    const char * cString = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cString, (CC_LONG)strlen((const char *)cString), result);
    NSString *sign= [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return [sign lowercaseString];
}

- (BOOL)isRegularEmail
{
    NSString *regulationStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        
//        [SeaGameAlertView showAlertViewWithMessage:[LocalizedStringReader getLocalizedStringForKey:@"emailError"] andActivityView:NO];
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularEmailWithoutAlert
{
    NSString *regulationStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {

        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularUserName
{
    NSString *regulationStr = @"^[a-zA-Z0-9]{6,20}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
//        [SeaGameAlertView showAlertViewWithMessage:[LocalizedStringReader getLocalizedStringForKey:@"userNameError"] andActivityView:NO];
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularChinaPhone
{
    NSString *regulationStr = @"^((13[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        //        [SeaGameAlertView showAlertViewWithMessage:[LocalizedStringReader getLocalizedStringForKey:@"userNameError"] andActivityView:NO];
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularPassword
{
    NSString *regulationStr = @"^.{6,20}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
//        [SeaGameAlertView showAlertViewWithMessage:[LocalizedStringReader getLocalizedStringForKey:@"passwordError"] andActivityView:NO];
        return NO;
    }
    
    return YES;
}

- (NSDictionary*)parseURL
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (NSString *)urlParamsToMD5
{
    NSDictionary *paramsDic = [self parseURL];
    
    NSArray *allParams = [paramsDic allValues];
    
    NSMutableString *paramsStr = [[NSMutableString alloc] initWithCapacity:10.0];
    
    for (NSString *param in allParams) {
        if ([param isEqualToString:@""]) {
            [paramsStr appendString:@"&"];
        }
        else
        {
            [paramsStr appendString:param];
        }
        
    }
    
    NSString *md5Str = [paramsStr getMD5Str];
    
    return md5Str;
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)timestrToTimeformat
{
    NSDate *date = [[NSDate date] initWithTimeIntervalSince1970:[self doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)testTimeString
{
    NSDate *date = [[NSDate date] initWithTimeIntervalSince1970:[self doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)time1970ToTimeformatymd
{
    NSDate *date = [[NSDate date] initWithTimeIntervalSince1970:[self doubleValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    return [formatter stringFromDate:date];
}

- (NSData *)dataWithBase64Encoded
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}
- (NSString *) utf8ToUnicode
{
    NSUInteger length = [self length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [self characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char    *cString = [subString UTF8String];
        //判断是否为英文和数字
        if ((0x4e00 < _char  && _char < 0x9fff) || strlen(cString) == 3)
        {
            unsigned short asciiCode = 92;
            [s appendFormat:@"%cu%x",asciiCode,[self characterAtIndex:i]];
            
        }
        else
        {
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }
        
    }
    return s;
}


- (NSString *)toMemoryBString {
    
    if (self.integerValue < 1024) {
        NSString *tempvalue = [NSString stringWithFormat:@"%@B",self];
        if (tempvalue.length == 1) {
            tempvalue = @"";
        }
        return tempvalue;
    } else if ((self.integerValue/1024) < 1024) {
        return [NSString stringWithFormat:@"%ldKB",self.integerValue/1024];
    } else if ((self.integerValue/1024/1024) < 1024) {
        return [NSString stringWithFormat:@"%ldMB",self.integerValue/1024/1024];
    } else if ((self.integerValue/1024/1024/1024) < 1024) {
        return [NSString stringWithFormat:@"%ldGB",self.integerValue/1024/1024/1024];
    } else {
        return [NSString stringWithFormat:@"%ldTB",self.integerValue/1024/1024/1024/1024];
    }
}


- (NSString *)toCapacityString {
    
    if (self.integerValue < 1024) {
        NSString *tempvalue = [NSString stringWithFormat:@"%@B",self];
        if (tempvalue.length == 1) {
            tempvalue = @"";
        }
        return tempvalue;
    } else if ((self.integerValue/1024) < 1024) {
        return [NSString stringWithFormat:@"%.2fKB",self.integerValue/1024.0];
    } else if ((self.integerValue/1024/1024) < 1024) {
        return [NSString stringWithFormat:@"%.2fMB",self.integerValue/1024/1024.0];
    } else if ((self.integerValue/1024/1024/1024) < 1024) {
        return [NSString stringWithFormat:@"%.2fGB",self.integerValue/1024/1024/1024.0];
    } else {
        return [NSString stringWithFormat:@"%.2fTB",self.integerValue/1024/1024/1024/1024.0];
    }
}



//- (BOOL)isIpv6 {
//    NSString *str = @"/^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
//    return [emailTest evaluateWithObject:email];
//}

@end
