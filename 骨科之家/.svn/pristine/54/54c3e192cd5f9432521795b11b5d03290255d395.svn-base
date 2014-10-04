//
//  ImageCache.h
//  VColleagueChat
//
//  Created by lqy on 5/6/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ABLUM_FOLER_DOCUMENT_NAME @"ablum_chatFoler"
@interface ImageCache : NSObject
+ (ImageCache *)sharedImageCache;
+ (NSString *)ablum_Foler;


+ (NSString *)filePathUrl:(NSString *)url;
+ (BOOL)storeImage:(id)data forUrl:(NSString *)url;
+ (BOOL)storeImage:(id)data forPath:(NSString *)path;
+ (BOOL)storeImage:(id)data forPath:(NSString *)path withQulity:(CGFloat)qulity;
@end
