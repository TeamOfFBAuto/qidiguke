//
//  UserAddedGroup.h
//  UNITOA
//
//  Created by qidi on 14-7-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteClass.h"
#import "GroupList.h"
@interface UserAddedGroupDB : NSObject
+ (void)addGroupInfo:(FMDatabase *)dataBase andkeyValue:(GroupList *)model andkeyArray:(NSArray *)key;
+ (void)updateGroupInfo:(FMDatabase *)dataBase andkeyValue:(GroupList *)model andkeyArray:(NSArray *)key;
+ (BOOL)selectGroupInfo:(NSString *)table andkeyValue:(GroupList *)model andkeyArray:(NSArray *)key;
+ (GroupList *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId;
+ (NSMutableArray *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId;

+ (void)delGroupInfo:(NSString *)groupId;

+ (void)updateGroupInfoByFeild:(FMDatabase *)dataBase andValue:(NSString *)value andKey:(NSString *)key andGroupId:(NSString *)groupId;
@end
