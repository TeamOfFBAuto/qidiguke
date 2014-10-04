//
//  userContactDB.h
//  UNITOA
//
//  Created by qidi on 14-7-28.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserContact.h"
#import "SqliteClass.h"
@interface userContactDB : NSObject
// 用户群组及联系人列表信息
+ (BOOL)selectuserContactInfo:(NSString *)table andkeyValue:(UserContact *)model andkeyArray:(NSArray *)key;
// 添加用户群组及联系人列表信息
+ (void)adduserContactInfo:(FMDatabase *)dataBase andkeyValue:(UserContact *)model andkeyArray:(NSArray *)key;
// 更新用户群组及联系人列表信息
+ (void)updateuserContactInfo:(FMDatabase *)dataBase andkeyValue:(UserContact *)model;
// 查询整个数据内容，返回数组
+ (NSMutableArray *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId;
// 查询某个字段
+ (NSString *)selectFeildbyelement:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)contactId;
// 置顶操作
+ (void)updateuserContactInfo:(FMDatabase *)dataBase andkeyValue:(UserContact *)model andString:(NSString *)isTop;
// 删除相应地群组
+ (void)delContactInfo:(NSString *)contactId;
@end
