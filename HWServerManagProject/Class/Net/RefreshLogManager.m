//
//  RefreshLogManager.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/21.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "RefreshLogManager.h"

static NSString *localIp = @"";

@implementation RefreshLogManager

+ (void)deletefileGiveUpLog {
    NSDate *date = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*10 sinceDate:date];//前10天
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTimeString = [formatter stringFromDate:lastDay];
    
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:homePath error:nil]];
        for (NSString *str in tempFileList) {
            NSArray *temparr = [str componentsSeparatedByString:@"."];
            if (temparr.count == 2) {
                NSString *str1 = temparr[0];
                if ([str1 compare:currentTimeString] == NSOrderedAscending) {
                    NSString *filePath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",str]];
                    [fileManager removeItemAtPath:filePath error:nil];
                }
            }
    }
}

+ (NSString *)getToDayLogPath {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTimeString = [formatter stringFromDate:date];
    
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSString *filePath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",currentTimeString]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return filePath;
    }
    return nil;
}

+ (void)writefile:(NSString *)string withTimeStr:(NSString *)timestr
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSString *filePath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",timestr]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]) {
        NSString *str = [NSString stringWithFormat:@"%@ \n\n",timestr];
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    NSString *str = [NSString stringWithFormat:@"\n\n%@",string];
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData]; //追加写入数据
    [fileHandle closeFile];
}


+ (void)writeLog:(NSString *)log withRedfish:(NSString *)uri {
    
    if ([HWGlobalData shared].curDevice) {
        NSString *currentTimeString = [self getCurrentTimes];
        NSString *ipaddress = [self getWANIPAddress];
        NSString *logStr = [NSString stringWithFormat:@"%@  %@  %@  %@  %@",currentTimeString,uri,[HWGlobalData shared].curDevice.account,ipaddress,log];
        [self writefile:logStr withTimeStr:[currentTimeString substringWithRange:NSMakeRange(0, 10)]];
    }
    
}



+ (NSString *)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


+ (NSString *)getWANIPAddress {
    
    if (localIp.length > 0) {
        return localIp;
    }
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BLLog(@"%@",dict);
        localIp = dict[@"cip"] ? dict[@"cip"] : @"";
        return localIp;
    }
    return @"";
}



@end
