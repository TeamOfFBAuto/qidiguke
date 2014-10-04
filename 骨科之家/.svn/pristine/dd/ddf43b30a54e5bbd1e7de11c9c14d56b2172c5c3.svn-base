//
//  Cache.m
//  VColleagueChat
//
//  Created by Ming Zhang on 14-6-10.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import "Cache.h"
#import "CCMD5.h"
@implementation Cache
// 创建缓存路径
+(NSString *)cacheFoler{
    NSError *error;
    NSString *folerPath = [DOCUMENTPATH stringByAppendingPathComponent:CACHE_FOLER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:folerPath]){
        BOOL res = [fileManager createDirectoryAtPath:folerPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return folerPath;
}
// 
+ (NSString *)cacheNameWithURL:(NSString *)suburl{
    NSString *filepath = nil;
    NSString *uid = GET_U_ID?[NSString stringWithFormat:@"%@",GET_U_ID]:nil;
    if (uid && suburl) {
        filepath = [[self cacheFoler] stringByAppendingPathComponent:[CCMD5 CCMDPathForKey:[NSString stringWithFormat:@"%@_%@",uid,suburl]]];
    }
    
    return filepath;
    
}
/*
 把数据写入文件 根据路径
 */
+(void)wirteInCacheFoler:(id)object withPath:(NSString *)path{
    NSError *error;
    NSString *folerPath = [DOCUMENTPATH stringByAppendingPathComponent:CACHE_FOLER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:folerPath]){
        BOOL res = [fileManager createDirectoryAtPath:folerPath withIntermediateDirectories:YES attributes:nil error:&error];
        //        NSAssert(res, @"创建目录失败 ");
        if (res) {
            
        }
    }
    // 开辟一个全局的子线程，将文件写入
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([fileManager fileExistsAtPath:path] && [fileManager isDeletableFileAtPath:path]) {
            //先删除原来的 重新写入
            NSError *error;
            if ([fileManager removeItemAtPath:path error:&error]) {
            }
        }
        BOOL res = [object writeToFile:path atomically:YES];
        if (res) {
            
        }else{
           
        }
    });
}
@end
