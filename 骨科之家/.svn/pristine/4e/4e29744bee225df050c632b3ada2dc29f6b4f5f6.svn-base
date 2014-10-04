 //
//  UncaughtExceptionHandler.m
//  Game
//
//  Created by WangYue on 13-7-17.
//  Copyright (c) 2013年 ntstudio.imzone.in. All rights reserved.
//


#import "MyUncaughtExceptionHandler.h"
#import "Interface.h"
#import "GetDateFormater.h"
NSString * applicationDocumentsDirectory()
{

    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
NSMutableString * FormatTime(NSString * time)
{
    NSArray *timeArray = [time componentsSeparatedByString:@" "];
    NSArray *subTimeArray = [[timeArray lastObject] componentsSeparatedByString:@":"];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",[timeArray firstObject]];
    
    for (int i = 0; i<[subTimeArray count]; ++i) {
        [string appendFormat:@"_%@",subTimeArray[i]];
    }
    return string;
    
}
void UncaughtExceptionHandler(NSException * exception)
{
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========EXCEPTION REPORT========\nUserId : %@\nUsername : %@\nCrashTime : %@\nDevice : %@\nOS Version : %@ %@\n\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",
                      GET_USER_ID,
                      GET_U_NAME,
                      [GetDateFormater getDate:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]],
                      [UIDevice currentDevice].model,
                      [UIDevice currentDevice].systemName,
                      [UIDevice currentDevice].systemVersion,
                      name,
                      reason,
                      [arr componentsJoinedByString:@"\n"]];
    NSString * currentTime = [GetDateFormater getDate:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.log",@"thunisoacrash",FormatTime(currentTime)];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:fileName];
    
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

    // 通过asi把错误报告上传到
    NSString *url1 = [NSString stringWithFormat:@"%@%@",BASE_URL,CRASH_REPORT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url1]];
    [request setFile: path forKey: @"file"];
    [request buildRequestHeaders];
    //NSLog(@"header: %@", request.requestHeaders);
    [request startSynchronous];
    //NSLog(@"responseString = %@", request.responseString);
  
    
}

@implementation MyUncaughtExceptionHandler

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception
{
    
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========EXCEPTION REPORT========\nUserId : %@\nUsername : %@\nCrashTime : %@\nDevice : %@\nOS Version : %@ %@\n\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",
                      GET_USER_ID,
                      GET_U_NAME,
                      [GetDateFormater getDate:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]],
                      [UIDevice currentDevice].model,
                      [UIDevice currentDevice].systemName,
                      [UIDevice currentDevice].systemVersion,
                      name,
                      reason,
                      [arr componentsJoinedByString:@"\n"]];
    NSString * currentTime = [GetDateFormater getDate:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.log",@"thunisoacrash",FormatTime(currentTime)];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:fileName];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

@end

