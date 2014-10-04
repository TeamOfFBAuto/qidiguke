//
//  UserInfoDB.h
//  UNITOA
//
//  Created by qidi on 14-7-23.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteClass.h"
#import "UserIfo.h"
@interface UserInfoDB : NSObject
+ (void)addUserInfo:(FMDatabase *)dataBase andkeyValue:(UserIfo *)model andkeyArray:(NSArray *)key;
+ (void)updateUserInfo:(FMDatabase *)dataBase andkeyValue:(NSString *)value andkey:(NSString *)key andWhereKey:(NSString *)userId;
+ (void)selectUserInfo:(NSString *)table andkeyValue:(UserIfo *)model andkeyArray:(NSArray *)key;
+ (NSString *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId anduserId:(NSString *)userId;
// 查询符合条件的数据量
+ (NSUInteger)selectCount:(NSString *)selectFeild andcuId:(NSString *)cuId;
@end
