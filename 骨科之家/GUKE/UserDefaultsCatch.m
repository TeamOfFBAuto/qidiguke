//
//  UserDefaultsCatch.m
//  WeiTongShi
//
//  Created by qidi on 14-6-9.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserDefaultsCatch.h"

@implementation UserDefaultsCatch

+ (void)saveCache:(int)type andID:(int)_id andString:(id)responseData
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:responseData forKey:key];
    [setting synchronize];
}

+ (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

+ (void)saveCache:(int)type andID:(int)_id andTypeName:(NSString *)name andString:(id)responseData
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"%@-%d-%d",name,type, _id];
    [setting setObject:responseData forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(int)type andID:(int)_id andTypeName:(NSString *)name
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%d-%d",name,type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}
@end
