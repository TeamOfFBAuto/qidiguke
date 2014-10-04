//
//  userContactDB.m
//  UNITOA
//
//  Created by qidi on 14-7-28.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "userContactDB.h"
#import "UserInfoDB.h"

@implementation userContactDB
+ (BOOL)selectuserContactInfo:(NSString *)table andkeyValue:(UserContact *)model andkeyArray:(NSArray *)key
{
    
    BOOL isDataChang = NO;
    // 定义查询字符串
    FMDatabase *dataBase = [SqliteClass creatDataBase:table andkeyArray:key];
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@= ?",table,@"cuId",@"contactId"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,GET_U_ID,model
                        .contactId];
    if ([set next]){
        isDataChang = NO;
    }
    else{
        [self adduserContactInfo:dataBase andkeyValue:model andkeyArray:key];
        isDataChang = YES;
    }
      
    [dataBase close];
    //dataBase = nil;
    return isDataChang;
}
// 添加用户群组及联系人列表信息
+ (void)adduserContactInfo:(FMDatabase *)dataBase andkeyValue:(UserContact *)model andkeyArray:(NSArray *)key
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
    sqlinsert = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",USERCONTACT_TABLE,feildsi,values];
    BOOL reg =  [dataBase executeUpdate:sqlinsert,
                 GET_U_ID,
                 [self JudgeIsempty:model.contactId],
                 [self JudgeIsempty:model.contactName],
                 [self JudgeIsempty:model.contactType],
                 [self JudgeIsempty:model.contactUsername],
                 [self JudgeIsempty:model.createDate],
                 [self JudgeIsempty:model.creator],
                 [self JudgeIsempty:model.creatorName],
                 [self JudgeIsempty:model.creatorUsername],
                 [self JudgeIsempty:model.groupType],
                 [self JudgeIsempty:model.lastMsg],
                 [self JudgeIsempty:model.lastMsgTime],
                 [self JudgeIsempty:model.lastMsgUser],
                 [self JudgeIsempty:model.lastMsgUserFirstname],
                 [self JudgeIsempty:model.lastMsgUserUsername],
                 @"0",
                 @"0",
                 @"0",
                 @"0"
                 ];
    
    if (reg) {
        // 关闭数据库
        [dataBase close];
    }

}
// 更新用户群组及联系人列表信息
+ (void)updateuserContactInfo:(FMDatabase *)dataBase andkeyValue:(UserContact *)model;
{
    FMDatabase *dataBase1 = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase1 open];
    if (!res) {
        [dataBase1 close];
        return;
    }
    NSString *sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?,%@ = ? ,%@ = ? WHERE %@ = ? AND %@ = ?",
                           USERCONTACT_TABLE,
                           @"lastMsgUser",
                           @"lastMsgTime",
                           @"lastMsg",
                           @"cuId",
                           @"contactId"
                           ];
    BOOL reg = [dataBase1 executeUpdate:sqlupdata,model.firstUsername,model.creatDate,model.context,
                GET_U_ID,model.contactId];
    if (reg) {
        NSLog(@"更新数据成功");
        [dataBase1 close];
    }
}
// 查询整个数据内容，返回数组
+ (NSMutableArray *)selectFeildString:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)contactId
{
    NSMutableArray *contactArray = [[NSMutableArray alloc]init];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return nil;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ORDER BY %@ ASC,%@ ASC,%@ DESC,%@ DESC,%@ DESC",USERCONTACT_TABLE,@"cuId",@"contactType",@"groupType",@"isTop",@"topOperateTime",@"lastMsgTime"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId];
    while([set next]){
        UserContact *model = [[UserContact alloc]init];
        model.contactId = [set stringForColumn:@"contactId"];
        model.contactName = [set stringForColumn:@"contactName"];
        model.contactType = [set stringForColumn:@"contactType"];
        model.contactUsername = [set stringForColumn:@"contactUsername"];
        model.createDate = [set stringForColumn:@"createDate"];
        model.creator = [set stringForColumn:@"creator"];
        model.creatorName = [set stringForColumn:@"creatorName"];
        model.creatorUsername = [set stringForColumn:@"creatorUsername"];
        model.groupType = [set stringForColumn:@"groupType"];
        model.lastMsg = [set stringForColumn:@"lastMsg"];
        model.lastMsgTime = [set stringForColumn:@"lastMsgTime"];
        model.lastMsgUser = [set stringForColumn:@"lastMsgUser"];
        model.lastMsgUserFirstname = [set stringForColumn:@"lastMsgUserFirstname"];
        model.lastMsgUserUsername = [set stringForColumn:@"lastMsgUserUsername"];
        model.memo = [set stringForColumn:@"memo"];
        model.isTop = [set stringForColumn:@"isTop"];
        model.topOperateTime = [set stringForColumn:@"topOperateTime"];
        model.isMute = [set stringForColumn:@"isMute"];
        model.lastMsgNum = [set stringForColumn:@"lastMsgNum"];
        //读取本地数据库的照片链接
        model.icon = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:model.contactId];
        [contactArray addObject:model];
        NSLog(@"%@",model.contactType);
        model = nil;
    }
    [dataBase close];
    dataBase = nil;
    return contactArray;
}
// 查询整个字段，返回数组
+ (NSString *)selectFeildbyelement:(NSString *)selectFeild andcuId:(NSString *)cuId andGroupId:(NSString *)contactId
{
    NSString *selectString = nil;
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return nil;
    }
    NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ORDER BY %@ DESC",USERCONTACT_TABLE,@"cuId",@"isTop"];
    FMResultSet *set = [dataBase executeQuery:sqlQue,cuId];
    if ([set next]){
        selectString  = [set stringForColumn:selectFeild];
    }
    [dataBase close];
    dataBase = nil;
    return selectString;
}
+ (void)updateuserContactInfo:(FMDatabase *)dataBase andkeyValue:(UserContact *)model andString:(NSString *)isTop
{
    FMDatabase *dataBase1 = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase1 open];
    if (!res) {
        [dataBase1 close];
        return;
    }
    NSString *sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?,%@ = ? WHERE %@ = ? AND %@ = ?",
                           USERCONTACT_TABLE,
                           @"isTop",
                           @"topOperateTime",
                           @"cuId",
                           @"contactId"
                           ];
    BOOL reg = [dataBase1 executeUpdate:sqlupdata,isTop,[NSString stringWithFormat:@"%@",[NSDate date]],GET_U_ID,model.contactId];
    if (reg) {
        NSLog(@"更新数据成功");
        [dataBase1 close];
    }
}
// 删除群组的信息
+ (void)delContactInfo:(NSString *)contactId
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        [dataBase close];
        return ;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ? ",USERCONTACT_TABLE,@"cuId",@"contactId"];
    NSLog(@"%@",GET_U_ID);
    res = [dataBase executeUpdate:deleteSql,GET_U_ID,contactId];
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
