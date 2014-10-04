//
//  UserInfoDB.m
//  UNITOA
//
//  Created by qidi on 14-7-23.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserInfoDB.h"
#import "SqliteClass.h"
@implementation UserInfoDB
// 程序开始运行时查询更新本地的用户数据是否存在
+ (void)selectUserInfo:(NSString *)table andkeyValue:(UserIfo *)model andkeyArray:(NSArray *)key
{
    // 定义查询字符串
    FMDatabase *dataBase = [SqliteClass creatDataBase:table andkeyArray:key];
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@= ?",table,@"cuId",@"userId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,GET_U_ID,model.userId];
    if ([set next]){
        NSString *iconUpdateTime = [set stringForColumn:@"iconUpdateTime"];
        NSString *bgUpdateTime = [set stringForColumn:@"bgUpdateTime"];
        if (![model.iconUpdateTime isEqualToString:iconUpdateTime]) {
            [self updateUserInfo:dataBase andkeyValue:model.icon andkey:@"icon" andWhereKey:model.userId];
            [self updateUserInfo:dataBase andkeyValue:model.iconUpdateTime andkey:@"iconUpdateTime" andWhereKey:model.userId];
        }
        if (![model.bgUpdateTime isEqualToString:bgUpdateTime]) {
            [self updateUserInfo:dataBase andkeyValue:model.articleBg andkey:@"articleBg" andWhereKey:model.userId];
            [self updateUserInfo:dataBase andkeyValue:model.bgUpdateTime andkey:@"bgUpdateTime" andWhereKey:model.userId];
        }
    }
    else{
        [self addUserInfo:dataBase andkeyValue:model andkeyArray:key];
    }
    [dataBase close];
    dataBase = nil;
}
+ (void)addUserInfo:(FMDatabase *)dataBase andkeyValue:(UserIfo *)model andkeyArray:(NSArray *)key
{
    // 创建数据库中得表
    NSString *feildsi = @"";
    NSString *values = @"";
    NSString *sqlinsert = nil;
    for (int i = 0; i < [key count]; i++)
    {
        if (i) {
            
            feildsi = [feildsi stringByAppendingString:[NSString stringWithFormat:@",%@",[key objectAtIndex:i]]];
            values = [values stringByAppendingString:@",?"];
        }
        else{
            feildsi = [NSString stringWithFormat:@"%@",[key objectAtIndex:i]];
            values = @"?";
        }
    }
    sqlinsert = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",USERIFO_TABLE,feildsi,values];
    
  BOOL reg =  [dataBase executeUpdate:sqlinsert,
               GET_U_ID,
     [self JudgeIsempty:model.userId],
     [self JudgeIsempty:model.username],
     [self JudgeIsempty:model.address],
     [self JudgeIsempty:model.allowPosition],
     [self JudgeIsempty:model.articleBg],
     [self JudgeIsempty:model.bgUpdateTime],
     [self JudgeIsempty:model.chkATime],
     [self JudgeIsempty:model.cityName],
     [self JudgeIsempty:model.company],
     [self JudgeIsempty:model.companyId],
     [self JudgeIsempty:model.district],
     [self JudgeIsempty:model.email],
     [self JudgeIsempty:model.firstname],
     [self JudgeIsempty:model.firstnameen],
     [self JudgeIsempty:model.icon],
     [self JudgeIsempty:model.iconUpdateTime],
     [self JudgeIsempty:model.inviteCodeId],
     [self JudgeIsempty:model.itcode],
     [self JudgeIsempty:model.lastChkETime],
     [self JudgeIsempty:model.latitude],
     [self JudgeIsempty:model.longitude],
     [self JudgeIsempty:model.memo],
     [self JudgeIsempty:model.mobile],
     [self JudgeIsempty:model.organization],
     [self JudgeIsempty:model.organizationen],
     [self JudgeIsempty:model.parentCode],
     [self JudgeIsempty:model.parentId],
     [self JudgeIsempty:model.position],
     [self JudgeIsempty:model.positionen],
     [self JudgeIsempty:model.province],
     [self JudgeIsempty:model.sex],
     [self JudgeIsempty:model.showMobile],
     [self JudgeIsempty:model.street],
     [self JudgeIsempty:model.street_number],
     [self JudgeIsempty:model.sysAdmin],
     [self JudgeIsempty:model.telephone],
     [self JudgeIsempty:model.versionName],
     [self JudgeIsempty:model.isFriend]
     ];
    if (reg) {
    }
    
}
// 程序启动时进行数据的更新
+ (void)updateUserInfo:(FMDatabase *)dataBase andkeyValue:(NSString *)value andkey:(NSString *)key andWhereKey:(NSString *)userId{
    if (dataBase == nil) {
        dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
        BOOL res = [dataBase open];
        if (!res) {
            NSAssert(!res, @"数据库打开失败");
            [dataBase close];
            return ;
        }
    }
  NSString *sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ? AND %@ = ?",
                 USERIFO_TABLE,
                key,
                @"cuId",
                @"userId"
                 ];
  BOOL reg = [dataBase executeUpdate:sqlupdata,value,GET_U_ID,userId];
    if (reg) {
    }

}
// 查询本地的数据
+ (NSString *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId anduserId:(NSString *)userId
{
    NSString *selectSttring = @"";
     FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return nil;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@= ?",USERIFO_TABLE,@"cuId",@"userId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId,userId];
    if ([set next]){
        selectSttring = [set stringForColumn:selectFeild];
    }
    else{
        selectSttring = @"";
    }
    [dataBase close];
    dataBase = nil;
    return selectSttring;
}
// 查询符合条件的数据量
+ (NSUInteger)selectCount:(NSString *)selectFeild andcuId:(NSString *)cuId
{
    NSUInteger count = 0;
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return count;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",USERIFO_TABLE,@"cuId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId];
    count = [set columnCount];
    [dataBase close];
    dataBase = nil;
    return count;
}
//判断是否为空，为空返回空得字符串
+ (NSString *)JudgeIsempty:(NSString *)string
{
    if (string.length) {
        return string;
    }
    else{
        return @"";
    }
}
//+ (NSString *)
@end
