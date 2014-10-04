//
//  ImageCache.m
//  VColleagueChat
//
//  Created by lqy on 5/6/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "ImageCache.h"
#import "CCMD5.h"
@implementation ImageCache
static ImageCache *instance;
+ (ImageCache *)sharedImageCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageCache alloc] init];
    });
    return instance;
}

+(NSString *)ablum_Foler{
    NSError *error;
    NSString *folerPath = [DOCUMENTPATH stringByAppendingPathComponent:ABLUM_FOLER_DOCUMENT_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:folerPath]){
        NSLog(@"执行这儿这句语句");
        BOOL res = [fileManager createDirectoryAtPath:folerPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (res) {
            NSLog(@"---------res成功执行");
        }
        NSAssert(res, @"创建目录失败");
    }
    return folerPath;
}

+ (NSString *)fileKey:(NSString *)fid type:(NSString *)type{
    if (!fid) return nil;
    return [CCMD5 CCMDPathForKey:[NSString stringWithFormat:@"%@_%@",fid,type]];
}
+ (NSString *)filepath:(NSString *)fid type:(NSString *)type{
    return [[ImageCache ablum_Foler] stringByAppendingPathComponent:[ImageCache fileKey:fid type:type]];
}


//
+ (NSString *)fileKeyURL:(NSString *)url{
    if (!url) return nil;
    return [CCMD5 CCMDPathForKey:url];
}

+ (NSString *)filePathUrl:(NSString *)url{
    return [[ImageCache ablum_Foler] stringByAppendingPathComponent:[ImageCache fileKeyURL:url]];
}
+ (BOOL)storeImage:(id)data forUrl:(NSString *)url{
    return [ImageCache storeImage:data forPath:[ImageCache filePathUrl:url]];
}
+ (BOOL)storeImage:(id)data forPath:(NSString *)path{
    return [ImageCache storeImage:data forPath:path withQulity:1];
}
+ (BOOL)storeImage:(id)data forPath:(NSString *)path withQulity:(CGFloat)qulity{
    NSData *data1 = nil;
    if (path && data) {
        if ([data isKindOfClass:[NSData class]]) {
            data1 = data;
        }else if ([data isKindOfClass:[UIImage class]]){
            data1 = UIImageJPEGRepresentation(data, qulity);
        }else{
            return NO;
        }
        BOOL res = [data1 writeToFile:path atomically:YES];
        if (res) {
            NSLog(@"写入成功---");
        }
    }
    return NO;
}
@end
