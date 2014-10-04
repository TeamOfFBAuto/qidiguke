//
//  GroupMember.m
//  UNITOA
//
//  Created by qidi on 14-7-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GroupMember.h"
#import "UserInfoDB.h"
@implementation GroupMember
+ (BOOL)selectGroupMemberInfo:(NSString *)table andkeyValue:(GroupMemberList *)model andkeyArray:(NSArray *)key
{
    BOOL isDataChang = NO;
    // 定义查询字符串
    FMDatabase *dataBase = [SqliteClass creatDataBase:table andkeyArray:key];
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@= ? AND %@= ?",table,@"cuId",@"groupId",@"userId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,GET_U_ID,GET_GROUPID,model
                        .userId];
    if ([set next]){
        isDataChang = NO;
    }
    else{
        [self addGroupMemberInfo:dataBase andkeyValue:model andkeyArray:key];
        isDataChang = YES;
    }
    [dataBase close];
    dataBase = nil;
    return isDataChang;
}
+ (void)addGroupMemberInfo:(FMDatabase *)dataBase andkeyValue:(GroupMemberList *)model andkeyArray:(NSArray *)key
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
    sqlinsert = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",GROUPMEMBER_TABLE,feildsi,values];
    
    BOOL reg =  [dataBase executeUpdate:sqlinsert,
                 GET_U_ID,
                 GET_GROUPID,
                 [self JudgeIsempty:model.userId],
                 [self JudgeIsempty:model.username],
                 [self JudgeIsempty:model.firstname],
                 [self JudgeIsempty:model.isCreator],
                 [self JudgeIsempty:model.addTime]
                 ];
    
    if (reg) {
        NSLog(@"插入数据成功");
        [dataBase close];
    }
}
+ (void)updateGroupMemberInfo:(FMDatabase *)dataBase andkeyValue:(GroupMemberList *)model andkeyArray:(NSArray *)key
{
    NSString *sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?,%@ = ?,%@ = ?,%@ = ? WHERE %@ = ? AND %@ = ? AND %@ = ?",
                           GROUPMEMBER_TABLE,
                           @"username",
                           @"firstname",
                           @"isCreator",
                           @"addTime",
                           @"cuId",
                           @"groupId",
                           @"userId"
                           ];
    BOOL reg = [dataBase executeUpdate:sqlupdata,model.username,model.firstname,model.isCreator,model.addTime, GET_U_ID,GET_GROUPID,model.username];
    if (reg) {
        NSLog(@"更新数据成功");
        [dataBase close];
    }


}
// 搜索所有组成员数据
+ (NSMutableArray *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId
{
    NSMutableArray *groupAreray = [[NSMutableArray alloc]init];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return nil;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?",GROUPMEMBER_TABLE,@"cuId",@"groupId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId,GET_GROUPID];
    while([set next]){
        GroupMemberList *model = [[GroupMemberList alloc]init];
        model.userId = [set stringForColumn:@"userId"];
        model.username = [set stringForColumn:@"username"];
        model.firstname = [set stringForColumn:@"firstname"];
        model.membermemo = [set stringForColumn:@"membermemo"];
        model.denytalk = [set stringForColumn:@"denytalk"];
        model.isCreator = [set stringForColumn:@"isCreator"];
        //读取本地数据库的照片链接
        model.icon = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:model.userId];
        [groupAreray addObject:model];
        model = nil;
    }
    [dataBase close];
    dataBase = nil;
    return groupAreray;
}
+ (GroupMemberList *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId andUserId:(NSString *)userId
{
    return nil;
}
// 删除群组全部成员
+ (void)delGroupMemberInfo:(NSString *)groupId
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return ;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ? ",GROUPMEMBER_TABLE,@"cuId",@"groupId"];
    res = [dataBase executeUpdate:deleteSql,GET_U_ID,groupId];
    if (res) {
        [dataBase close];
    }
    else{
        [dataBase close];
    }

}
// 删除群组的指定成员
+ (void)delGroupMemberInfo:(NSString *)groupId andUserId:(NSString *)userId
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return ;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ?",GROUPMEMBER_TABLE,@"cuId",@"groupId",@"userId"];
    res = [dataBase executeUpdate:deleteSql,GET_U_ID,groupId,userId];
    if (res) {
        [dataBase close];
    }
    else{
        [dataBase close];
    }
    
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
@end
