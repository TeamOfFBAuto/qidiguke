//
//  GroupMember.h
//  UNITOA
//
//  Created by qidi on 14-7-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupMemberList.h"
#import "SqliteClass.h"
@interface GroupMember : NSObject
// 添加群组用户信息
+ (void)addGroupMemberInfo:(FMDatabase *)dataBase andkeyValue:(GroupMemberList *)model andkeyArray:(NSArray *)key;
// 更新群组用户信息
+ (void)updateGroupMemberInfo:(FMDatabase *)dataBase andkeyValue:(GroupMemberList *)model andkeyArray:(NSArray *)key;
// 查询群组用户信息
+ (BOOL)selectGroupMemberInfo:(NSString *)table andkeyValue:(GroupMemberList *)model andkeyArray:(NSArray *)key;
// 根据字段返回查询的内容
+ (GroupMemberList *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId andUserId:(NSString *)userId;
// 查询整个数据内容，返回数组
+ (NSMutableArray *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId;
// 删除群组内烦人所有成员
+ (void)delGroupMemberInfo:(NSString *)groupId;
// 删除群组内指定的成员
+ (void)delGroupMemberInfo:(NSString *)groupId andUserId:(NSString *)userId;
@end
