//
//  AFNetAPIClient.m
//  WeiTongShi
//
//  Created by qidi on 14-6-2.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AFNetAPIClient.h"
#import "Interface.h"
@implementation AFNetAPIClient
+(instancetype)shareClient{
    static AFNetAPIClient *_shareClient = nil;
    static dispatch_once_t _onceTocken;
    dispatch_once(&_onceTocken, ^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
        
        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存50M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        _shareClient = [[AFNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] sessionConfiguration:config];// 设置缓存
        _shareClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _shareClient;
}
@end
