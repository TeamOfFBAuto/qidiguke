//
//  AFRequestService.h
//  WeiTongShi
//
//  Created by qidi on 14-6-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetAPIClient.h"
//#import "Interface.h"
typedef void(^getDataBlock)(NSData *responseData);
typedef void(^refreshNewData) (NSData * responseNewData);
typedef void(^failWithRequest)(void);
@interface AFRequestService : NSObject
@property (nonatomic, strong)refreshNewData refreshData;
// 不添加缓存机制的数据请求
+ (void)responseData:(NSString *)requestURL andparameters:(NSDictionary *)parameters andResponseData:(getDataBlock)getdata;
+(void)responseData:(NSString *)requestURL andparameters:(NSDictionary *)parameters andResponseData:(getDataBlock)getdata andFailfailWithRequest:(failWithRequest)failRequest;
// 上传图片的数据请求
+ (void)responseDataWithImage:(NSString *)requestURL andparameters:(NSDictionary *)parameters andImageData:(NSData *)ImageData andfieldType:(NSString *)typeName andfileName:(NSString *)name andResponseData:(getDataBlock)getdata;
// 添加缓存带有类型名的区分
+ (void)responseData:(NSString *)requestURL andparameters:(NSDictionary *)parameters andResponseData:(getDataBlock)getdata andCathtype:(int)type andID:(int)_id andtypeName:(NSString *)name;

//  上传文件的方法
+ (void)responseDataWithFile:(NSString *)requestURL andparameters:(NSDictionary *)parameters andImageData:(NSData *)ImageData andfieldType:(NSString *)typeName andfileName:(NSString *)name andMimeType:(NSString *)mimeTypeName andResponseData:(getDataBlock)getdata;

// 上传音频文件
+ (void)responseDataWithImage:(NSString *)requestURL andparameters:(NSDictionary *)parameters andDataArray:(NSMutableArray *)dataArray andfieldType:(NSString *)typeName andfileName:(NSString *)name andResponseData:(getDataBlock)getdata;
///病例库上传多文件
+ (void)bingliresponseDataWithImage:(NSString *)requestURL andparameters:(NSDictionary *)parameters andDataArray:(NSMutableArray *)dataArray andfieldType:(NSString *)typeName andfileName:(NSString *)name andResponseData:(getDataBlock)getdata;

@end
