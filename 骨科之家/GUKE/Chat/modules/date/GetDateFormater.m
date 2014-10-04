//
//  GetDateFormater.m
//  Starway
//
//  Created by Ming Zhang on 13-8-6.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import "GetDateFormater.h"

@implementation GetDateFormater
+(NSString *)getDate:(NSString *)format withDate:(NSDate *)date{
    //[self performSelector:@selector(getDate:withDate:) withObject:@"yyyy-MM-dd" withObject:[NSDate date]];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    NSString *  currentTime=[dateformatter stringFromDate:date];
    if (!currentTime) {
        currentTime = @"";
    }
    [dateformatter release];
    return currentTime;
}


//将时间字符串转化成NSDate型数据
+(NSDate *)get:(NSString *)string with:(NSString *)format {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    [dateformatter setLocale:locale];
    //    [locale release];
    [dateformatter setDateFormat:format];
    [dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *outputDate = [dateformatter dateFromString:string];
    [dateformatter release];
    return outputDate ;
}
//判断两个时间间隔是否超过一个时间段 after 之后 befor 之前
+(BOOL)compafterNowStr:(NSString *)dateAfter beforDate:(NSString *)dateBefor with:(NSString *)format interval:(NSTimeInterval )sec{
    
    
    
    NSDate *dateBe = [NSDate dateWithTimeInterval:sec sinceDate:[self get:dateBefor with:format]];//
    //    NSLog(@"%@",dateBe);
    
    
    NSDate *dateAf = [self get:dateAfter with:format];
    //以dateAf为准
    if ([dateBe compare:dateAf] == NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}
//日期比较
+(BOOL)compafterDate:(NSDate *)dateAfter beforDate:(NSDate *)dateBefor withInterVal:(NSTimeInterval )sec{
    if ([dateBefor compare:dateAfter] == NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}

//格式话时间显示 今天就显示 时分
+(NSString *)getShowDateStr:(NSString *)dateStr{
    NSString *strShow = nil;
    if (!dateStr) {
        return strShow;
    }
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:DATE_FORMAT];
    NSString *str = [[dateStr componentsSeparatedByString:@"."] objectAtIndex:0];
    NSDate *date = nil;
    if (str) {
        date = [dateformatter dateFromString:str];
    }
    NSString *today = [self getDate:DATE_FORMAT withDate:[NSDate date]];
    if (!today) {
        return strShow;
    }
    NSString *strToday_T = [[today  componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *strDate_T = [[dateStr componentsSeparatedByString:@" "] objectAtIndex:0];
    //如果是今天 那么显示HH:mm
    if ([strToday_T isEqualToString:strDate_T]) {
        if (date) {
            strShow = [self getDate:@"HH:mm" withDate:date];
        }
    }
    //如果不是 那么看是否是今年
    else {
        NSString *strToday_Y = [[today  componentsSeparatedByString:@"-"] objectAtIndex:0];
        NSString *strDate_Y = [[dateStr componentsSeparatedByString:@"-"] objectAtIndex:0];
        if ([strToday_Y isEqualToString:strDate_Y]) {
            if (date) {
                strShow = [self getDate:@"MM月dd日 HH:mm" withDate:date];
            }
        }else{
            if (date) {
                strShow = [self getDate:@"yyyy年MM月dd日 HH:mm" withDate:date];
            }
        }
    }
    return strShow;
}
@end
