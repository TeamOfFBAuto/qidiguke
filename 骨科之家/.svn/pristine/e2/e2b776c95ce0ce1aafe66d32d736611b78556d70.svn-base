//
//  UserAddedGroup.m
//  UNITOA
//
//  Created by qidi on 14-7-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserAddedGroupDB.h"

@implementation UserAddedGroupDB

// 查找服务器上的数据是否存在数据库中，存在若有改变则更新，不存在则插入到数据库中
+ (BOOL)selectGroupInfo:(NSString *)table andkeyValue:(GroupList *)model andkeyArray:(NSArray *)key
{
    // 创建数据库表
    BOOL flag = NO;
    FMDatabase *dataBase = [SqliteClass creatDataBase:table andkeyArray:key];
    
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@= ?",table,@"cuId",@"groupId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,GET_U_ID,model.groupId];
    if ([set next]){
        flag = NO;
        NSString *createDate = [set stringForColumn:@"createDate"];
        NSString *groupName = [set stringForColumn:@"groupName"];
        NSString *memo = [set stringForColumn:@"memo"];
        if (![createDate isEqualToString:model.createDate]) {
            [self updateGroupInfo:dataBase andkeyValue:model andkeyArray:nil];
        }
        if (![groupName isEqualToString:model.groupName]) {
            [self updateGroupInfoByFeild:dataBase andValue:model.groupName andKey:@"groupName" andGroupId:model.groupId];
        }
        if (![memo isEqualToString:model.memo]) {
            [self updateGroupInfoByFeild:dataBase andValue:model.memo andKey:@"memo" andGroupId:model.groupId];
        }
        
    }
    else{
        flag = YES;
        [self addGroupInfo:dataBase andkeyValue:model andkeyArray:key];
    }
    // 数据库运行完，解锁关闭
    [dataBase close];
    return flag;
}
+ (void)addGroupInfo:(FMDatabase *)dataBase andkeyValue:(GroupList *)model andkeyArray:(NSArray *)key;
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
    sqlinsert = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",USERADDEDGROUP_TABLE,feildsi,values];
    
    BOOL reg =  [dataBase executeUpdate:sqlinsert,
                 GET_U_ID,
                 [self JudgeIsempty:model.groupId],
                 [self JudgeIsempty:model.groupName],
                 [self JudgeIsempty:model.groupType],
                 [self JudgeIsempty:model.creator],
                 [self JudgeIsempty:model.creatorName],
                 [self JudgeIsempty:model.isCreator],
                 [self JudgeIsempty:model.addTime],
                 [self JudgeIsempty:model.createDate],
                 [self JudgeIsempty:model.denytalk],
                 [self JudgeIsempty:model.latestMsg],
                 [self JudgeIsempty:model.latestMsgUser],
                 [self JudgeIsempty:model.latestMsgUserName],
                 [self JudgeIsempty:model.membermemo],
                 [self JudgeIsempty:model.memo]
                 ];

    if (reg) {
        NSLog(@"插入数据成功");
        [dataBase close];
    }

}
// 程序启动时更新群组的信息
+ (void)updateGroupInfo:(FMDatabase *)dataBase andkeyValue:(GroupList *)model andkeyArray:(NSArray *)key;
{
    NSString *sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?,%@ = ?,%@ = ?,%@ = ? WHERE %@ = ? AND %@ = ?",
                           USERIFO_TABLE,
                           @"groupName",
                           @"memo",
                           @"addTime",
                           @"createDate",
                           @"cuId",
                           @"groupId"
                           ];
    BOOL reg = [dataBase executeUpdate:sqlupdata,model.groupName,model.memo,model.addTime,model.createDate, GET_U_ID,model.groupId];
    if (reg) {
        NSLog(@"更新数据成功");
        [dataBase close];
    }
}
// 根据字段更新相应地内容
+ (void)updateGroupInfoByFeild:(FMDatabase *)dataBase andValue:(NSString *)value andKey:(NSString *)key andGroupId:(NSString *)groupId
{
    if (dataBase == nil) {
        dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
        BOOL res = [dataBase open];
        if (!res) {
            NSAssert(!res, @"数据库打开失败");
            [dataBase close];
            return;
        }

    }
    NSString *sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ? AND %@ = ?",
                           USERADDEDGROUP_TABLE ,
                           key,
                           @"cuId",
                           @"groupId"
                           ];
    BOOL reg = [dataBase executeUpdate:sqlupdata,value,GET_U_ID,groupId];
    if (reg) {
        NSLog(@"更新数据成功");
        [dataBase close];
    }
}
// 查询某个群组的信息
+ (GroupList *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)groupId
{
    GroupList *model = [[GroupList alloc]init];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return nil;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@= ?",USERADDEDGROUP_TABLE,@"cuId",@"groupId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId,groupId];
    if ([set next]){
        model.addTime = [set stringForColumn:@"addTime"];
        model.createDate = [set stringForColumn:@"createDate"];
        model.creator = [set stringForColumn:@"creator"];
        model.creatorName = [set stringForColumn:@"creatorName"];
        model.denytalk = [set stringForColumn:@"denytalk"];
        model.groupId = [set stringForColumn:@"groupId"];
        model.groupName = [set stringForColumn:@"groupName"];
        model.groupType = [set stringForColumn:@"groupType"];
        model.isCreator = [set stringForColumn:@"isCreator"];
        model.latestMsg = [set stringForColumn:@"latestMsg"];
        model.latestMsgUser = [set stringForColumn:@"latestMsgUser"];
        model.latestMsgUserName = [set stringForColumn:@"latestMsgUserName"];
        model.membermemo = [set stringForColumn:@"membermemo"];
        model.memo = [set stringForColumn:@"memo"];
    }
    else{
    }
    [dataBase close];
    dataBase = nil;
    return model;

}
// 查询群组的所有数据
+ (NSMutableArray *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId
{
    
    NSMutableArray *groupAreray = [[NSMutableArray alloc]init];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return nil;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",USERADDEDGROUP_TABLE,@"cuId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId];
    while([set next]){
        GroupList *model = [[GroupList alloc]init];
        model.addTime = [set stringForColumn:@"addTime"];
        model.createDate = [set stringForColumn:@"createDate"];
        model.creator = [set stringForColumn:@"creator"];
        model.creatorName = [set stringForColumn:@"creatorName"];
        model.denytalk = [set stringForColumn:@"denytalk"];
        model.groupId = [set stringForColumn:@"groupId"];
        model.groupName = [set stringForColumn:@"groupName"];
        model.groupType = [set stringForColumn:@"groupType"];
        model.isCreator = [set stringForColumn:@"isCreator"];
        model.latestMsg = [set stringForColumn:@"latestMsg"];
        model.latestMsgUser = [set stringForColumn:@"latestMsgUser"];
        model.latestMsgUserName = [set stringForColumn:@"latestMsgUserName"];
        model.membermemo = [set stringForColumn:@"membermemo"];
        model.memo = [set stringForColumn:@"memo"];
        [groupAreray addObject:model];
        model = nil;
    }
    [dataBase close];
    dataBase = nil;
    return groupAreray;
    
}
// 删除群组的信息
+ (void)delGroupInfo:(NSString *)groupId
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return ;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ? ",USERADDEDGROUP_TABLE,@"cuId",@"groupId"];
    NSLog(@"%@",GET_U_ID);
    res = [dataBase executeUpdate:deleteSql,GET_U_ID,groupId];
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
