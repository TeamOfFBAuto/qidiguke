//
//  Cache.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-6-10.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//
#define CACHE_FOLER @"cachefoler"
#import <Foundation/Foundation.h>

@interface Cache : NSObject
+ (NSString *)cacheNameWithURL:(NSString *)suburl;
+(void)wirteInCacheFoler:(id)object withPath:(NSString *)path;
@end
