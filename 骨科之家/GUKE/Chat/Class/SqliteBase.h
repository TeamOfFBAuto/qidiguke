//
//  SqliteBase.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-5-23.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VChatModel.h"
#define TABLE_HD @"hdtable"
@interface SqliteBase : NSObject
+ (void)witeInbase:(NSString *)table withData:(NSArray *)datas;
+ (NSArray *)readbase:(NSString *)table query:(NSDictionary *)dic count:(NSUInteger)count;
+ (BOOL)isInDataBase:(NSString *)hdid;
// 更新文件是否已读
+ (void)updateInbase:(NSString *)table withData:(id)object;
// 读取数据库中符合条件的数据的条数
+ (NSInteger)readDataCount:(NSString *)table query:(NSDictionary *)dic;
+ (void)deleteData:(NSString *)table andArticleId:(NSInteger)articleId;
@end