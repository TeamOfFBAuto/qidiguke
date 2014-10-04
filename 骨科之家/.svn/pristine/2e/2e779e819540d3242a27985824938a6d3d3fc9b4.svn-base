//
//  LoadToLocal.h
//  UNITOA
//
//  Created by qidi on 14-9-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadToLocal : NSObject
{
    NSURLConnection *connection;
    NSMutableData *loadData;
}
//图片对应的缓存在沙河中的路径
@property (nonatomic, retain) NSString *fileName;
//请求网络图片的URL
@property (nonatomic, retain) NSString *URL;
- (NSString *)getFileUrl:(NSString *)URL andfile:(NSData *)fileData;
@end
