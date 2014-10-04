//
//  SqliteBase.m
//  VColleagueChat
//
//  Created by lqy on 5/21/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "SqliteBase.h"
#import "FMDatabase.h"
@implementation SqliteBase
#define DATABASE_FOLER @"database_folder"
#define ENGLISH_CLIENT @"vchatclient.db"
//创建数据库文件夹
+(NSString *)dataBaseFoler{
    NSError *error;
    NSString *folerPath = [DOCUMENTPATH stringByAppendingPathComponent:DATABASE_FOLER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:folerPath]){
        BOOL res = [fileManager createDirectoryAtPath:folerPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(res, @"创建目录失败 ");
    }
    //NSLog(@"%@",folerPath);
    return folerPath;
}
+(NSString *)querAndCreatChateMessageDatabasePath{
    return [[self dataBaseFoler] stringByAppendingPathComponent:ENGLISH_CLIENT];
}

//统一存储聊天信息 这儿就不做单独封装数据存储了
+ (void)witeInbase:(NSString *)table withData:(NSArray *)datas{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];
    
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        return;
    }
    //NSLog(@"数据库位置:%@",[SqliteBase querAndCreatChateMessageDatabasePath]);
    NSMutableArray *key = [NSMutableArray arrayWithObjects:
                           @"ukey",//用户自身标识 ---根据用户缓存数据
                           
                           @"articleId",
                           @"context",
                           @"attachId",@"filename",@"fileurl",@"voiceLength",
                           //                           @"attachId2",@"filename2",@"fileurl2",@"voiceLength2",可以按照这种方式存储 暂时没必要单独把所有附件放在另外一个表中
                           //                           @"companyId",
                           //                           @"deleteFlag",
                           //                           @"lastReply",
                           //                           @"picurl",
                           //                           @"readCount",
                           //                           @"voiceurl",
                           
                           @"createDate",
                           @"firstUsername",
                           @"firstname",
                           @"icon",
                           @"iconUpdateTime",
                           
                           @"isGroupArticle",
                           @"recvId",    //收信人id，仅站内信分类才有值，否则为0；或者接收的群组id
                           @"typeId",
                           
                           @"uid",//自己发送的标识
                           @"userId",//发送人id
                           @"shareSource",
                           @"shareId",
                           @"isRead",
                           @"issend",
                           nil];
    NSString *sqlC = nil;
    NSString *feild = nil;
    NSString *feildsi = @"";
    NSString *values = @"";
    NSString *sqlupdata = nil;
    NSString *sqlinsert = nil;
    for (int i = 0; i < key.count; i++) {
        if (i) {
            if (i == 1) {
                feild = [feild stringByAppendingString:[NSString stringWithFormat:@",%@ INTEGER",[key objectAtIndex:i]]];
            }else{
                feild = [feild stringByAppendingString:[NSString stringWithFormat:@",%@ TEXT",[key objectAtIndex:i]]];
            }
            feildsi = [feildsi stringByAppendingString:[NSString stringWithFormat:@",%@",[key objectAtIndex:i]]];
            values = [values stringByAppendingString:@",?"];
        }else{
            feild = [NSString stringWithFormat:@"%@ TEXT",[key objectAtIndex:i]];
            feildsi = [NSString stringWithFormat:@"%@",[key objectAtIndex:i]];
            values = @"?";
        }
    }
    sqlC = [NSString stringWithFormat:@"CREATE TABLE %@(%@)",table,feild];
    ////NSLog(@"sqlC --- >%@",sqlC);
    [dataBase executeUpdate:sqlC];//创建数据库
    sqlinsert = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",table,feildsi,values];
    
    
    //NSLog(@"sqlinsert --- 语句:%@",sqlinsert);
    // 更新数据库中的数据
    if ([table isEqualToString:TABLE_HD]) {
        sqlupdata = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ? ,%@ = ?,%@ = ? ,%@ = ?  WHERE %@ = ? AND %@ = ?",
                     TABLE_HD,
                     @"context",
                     @"attachId",
                     @"filename",
                     @"fileurl",
                     @"voiceLength",
                     @"createDate",
                     @"firstUsername",
                     @"firstname",
                     @"icon",
                     @"iconUpdateTime",
                     
                     @"isGroupArticle",
                     @"recvId",
                     @"typeId",
                     
                     @"uid",//自己发送的标识
                     @"userId",
                     @"issend",
                     @"shareSource",
                     @"shareId",
                     @"ukey",//用户自身标识 ---根据用户缓存数据
                     @"articleId"
                     ];
        
    }
    
    @try {
        NSString *ukey = GET_U_ID;
        if (!ukey) {
            return;
        }
        
        for (VChatModel *model in datas) {
            if ([model isKindOfClass:[VChatModel class]]) {
                NSString *articleId = [NSString stringWithFormat:@"%d",model.articleId];
                
//                NSInteger articleId = model.articleId;
                NSString *context = model.context?model.context:@"";
                
                
                NSString *attachId = @"";
                NSString *filename = @"";
                NSString *fileurl = @"";
                NSString *voiceLength = @"";
                NSArray *atts = model.attachlist;
                // 是否带有附件
                if (atts.count) {
                    VChatAttachModel *att = [atts objectAtIndex:0];
                    attachId = att.attachId?att.attachId:@"";
                    filename = att.filename?att.filename:@"";
                    fileurl = att.fileurl?att.fileurl:@"";
                    voiceLength = att.voiceLength?att.voiceLength:@"";
                }
                NSString *createDate = model.creatDate?model.creatDate:@"";
                NSString *firstUsername = model.firstname?model.firstUsername:@"";
                NSString *firstname = model.firstname?model.firstname:@"";
                NSString *icon = model.icon?model.icon:@"";
                NSString *iconUpdateTime = model.iconUpdateTime?model.iconUpdateTime:@"";
                NSString *isGroupArticle = model.isGroupArticle?model.isGroupArticle:@"";
                NSString *recvId = model.recvId?model.recvId:@"";
                NSString *typeId = model.typeId?model.typeId:@"";
                NSString *isRead = @"0";// 标注声音文件是否已读
                NSString *issend = model.isSend?model.isSend:@"";// 标注声音文件是否已读
                NSString *uid = model.uid?model.uid:@"";
                NSString *userid = model.userId?model.userId:@"";
                NSString *shareSource = model.shareSource?model.shareSource:@"";
                NSString *shareId = model.shareId?model.shareId:@"";
                
                NSString *sqlQue = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?",table,@"ukey",@"articleId"];
                FMResultSet *set = [dataBase executeQuery:sqlQue,ukey,articleId];
                
                if ([set next]) {
                   // 数据有在，则更新
                    res = [dataBase executeUpdate:sqlupdata,context,attachId,filename,fileurl,voiceLength,createDate,firstUsername,firstname,icon,iconUpdateTime,isGroupArticle,recvId,typeId,uid,userid,issend,shareSource,shareId,ukey,articleId];
                    if (res) {
                        NSLog(@"update suc");
                    }else{
                        NSLog(@"update error");
                    }
                }else{
                    // 数据不在，则插入
                    res = [dataBase executeUpdate:sqlinsert,ukey,articleId,context,attachId,filename,fileurl,voiceLength,createDate,firstUsername,firstname,icon,iconUpdateTime,isGroupArticle,recvId,typeId,uid,userid,shareSource,shareId,isRead,issend];
                    if (res) {
                        NSLog(@"插入数据成");
                    }else{
                        NSLog(@"insert error");
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [dataBase close];
}
// 读取数据库中的信息
+ (NSArray *)readbase:(NSString *)table query:(NSDictionary *)dic count:(NSUInteger)count{
    NSMutableArray *datas = [NSMutableArray array];
    
    
    NSString *isGroupArticle = [dic objectForKey:@"isGroupArticle"];
    NSString *recvId = [dic objectForKey:@"recvId"];
    NSString *typeId = [dic objectForKey:@"typeId"];

    NSString *articleId = [dic objectForKey:@"articleId"];
    NSString *ukey = GET_U_ID;
    
    if (!ukey || !isGroupArticle || !recvId || !typeId || !articleId) {
        return datas;
    }
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];//
    BOOL res = [dataBase open];
    if (!res) {
      //  NSLog(@"数据库打开失败");
        return datas;
    }
    NSString *sql = nil;
    FMResultSet *set = nil;
    
    if ([typeId isEqualToString:@"10"]) {
        //私聊
        NSString *userId = ukey;
        // 最大的id降序开始查起
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND ((%@ = ? AND %@ = ?) OR (%@ = ? AND %@ = ?)) ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"typeId",@"recvId",@"userId",@"recvId",@"userId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,typeId,recvId,userId,userId,recvId];
            
        }
        // 给定指定的articleId降序插旗
        else{
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ?AND ((%@ = ? AND %@ = ?) OR (%@ = ? AND %@ = ?)) AND %@ < ?  ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"typeId",@"recvId",@"userId",@"recvId",@"userId",@"articleId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,typeId,recvId,userId,userId,recvId,articleId];
            
        }
    }
    // 聊天广场
    else if ([typeId isEqualToString:@"9"]){
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId];
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? AND %@ < ?  ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId,articleId];
        }
        
    }
    // 群组聊天
    else{
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId];
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? AND %@ < ?  ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId,articleId];
        }
    }

    //NSLog(@"sql --- >data数据:%@",sql);
    while ([set next]) {
        VChatModel *model = [[VChatModel alloc] init];
        NSInteger articleId = [set intForColumn:@"articleId"];
        NSString *context = [set stringForColumn:@"context"];
        
        // 读取的声音和图片的附件内容
        NSString *attachId = [set stringForColumn:@"attachId"];
        NSString *filename = [set stringForColumn:@"filename"];
        NSString *fileurl = [set stringForColumn:@"fileurl"];
        NSString *voiceLength = [set stringForColumn:@"voiceLength"];
        
        
        // 整条数据的信息
        NSString *createDate = [set stringForColumn:@"createDate"];
        NSString *userid = [set stringForColumn:@"userid"];
        NSString *firstUsername = [set stringForColumn:@"firstUsername"];
        NSString *firstname = [set stringForColumn:@"firstname"];
        NSString *icon = [set stringForColumn:@"icon"];
        NSString *iconUpdateTime = [set stringForColumn:@"iconUpdateTime"];
        NSString *isGroupArticle = [set stringForColumn:@"isGroupArticle"];
        NSString *recvId = [set stringForColumn:@"recvId"];
        NSString *typeId = [set stringForColumn:@"typeId"];
        NSString *issend = [set stringForColumn:@"issend"];
        NSInteger isPlayed = [[set stringForColumn:@"isRead"] integerValue];
        
        NSString *shareSource = [set stringForColumn:@"shareSource"];
        NSString *shareId = [set stringForColumn:@"shareId"];
        
        NSString *uid = [set stringForColumn:@"uid"];
        
        
        model.articleId = articleId;
        model.context = context;
        model.creatDate = createDate;
        model.userId = userid;
        model.firstUsername = firstUsername;
        model.firstname = firstname;
        model.icon = icon;
        model.iconUpdateTime = iconUpdateTime;
        model.isGroupArticle = isGroupArticle;
        model.recvId = recvId;
        model.typeId = typeId;
        model.isSend = issend;
        model.shareSource = shareSource;
        model.shareId = shareId;
        model.uid = uid;
        
        // 判断文件的类型
        if (attachId.length) {
           // NSLog(@"---attachId:%@,fileurl:%@",attachId,fileurl);
            if ([fileurl hasSuffix:@".amr"]) {
             //  (文件类型为语音) NSLog(@"---》查询个数＋＋语言");
                model.sendType = SEND_Type_voice;
            }else{
             // （文件类型为图片）NSLog(@"---》查询个数＋＋图片");
                model.sendType = SEND_Type_photo;
            }
            
            VChatAttachModel *att = [[VChatAttachModel alloc] init];
            att.attachId = attachId;
            att.filename = filename;
            att.fileurl = fileurl;
            att.voiceLength = voiceLength;
            att.isRead = isPlayed; // 标注声音是否被播放
            [model.attachlist addObject:att];
            
            SSRCRelease(att)
            
        }else{
            model.sendType = SEND_Type_content;
        }
        
        
       // NSLog(@"---》查询个数＋＋");
        [datas addObject:model];
        
        SSRCRelease(model)
    }
    
   // NSLog(@"%d:%sdb:sqlite---%d",__LINE__,__func__,[datas count]);
    return datas;
}
// 读取数据库中的信息最新信息
+ (NSArray *)readbase1:(NSString *)table query:(NSDictionary *)dic count:(NSUInteger)count{
    NSMutableArray *datas = [NSMutableArray array];
    
    
    NSString *isGroupArticle = [dic objectForKey:@"isGroupArticle"];
    NSString *recvId = [dic objectForKey:@"recvId"];
    NSString *typeId = [dic objectForKey:@"typeId"];
    
    NSString *articleId = [dic objectForKey:@"articleId"];
    NSString *ukey = GET_U_ID;
    
    if (!ukey || !isGroupArticle || !recvId || !typeId || !articleId) {
        return datas;
    }
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];//
    BOOL res = [dataBase open];
    if (!res) {
       // NSLog(@"数据库打开失败");
        return datas;
    }
    NSString *sql = nil;
    FMResultSet *set = nil;
    
    if ([typeId isEqualToString:@"10"]) {
        //私聊
        NSString *userId = [dic objectForKey:@"userId"];
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND ((%@ = ? AND %@ = ?) OR (%@ = ? AND %@ = ?)) ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"typeId",@"recvId",@"userId",@"recvId",@"userId",@"articleId",100];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,typeId,recvId,userId,userId,recvId];
            
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND (%@ = ? OR %@ = ?) AND %@ < ?  ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"typeId",@"recvId",@"userId",@"articleId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,typeId,recvId,userId,articleId];
            
        }
    }else{
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId];
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? AND %@ < ?  ORDER BY %@ DESC LIMIT %d",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId",@"articleId",count];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId,articleId];
        }
    }
    
    
    //NSLog(@"sql --- >data数据:%@",sql);
    while ([set next]) {
        VChatModel *model = [[VChatModel alloc] init];
        NSInteger articleId = [set intForColumn:@"articleId"];
        NSString *context = [set stringForColumn:@"context"];
        
        
        NSString *attachId = [set stringForColumn:@"attachId"];
        NSString *filename = [set stringForColumn:@"filename"];
        NSString *fileurl = [set stringForColumn:@"fileurl"];
        NSString *voiceLength = [set stringForColumn:@"voiceLength"];
        
        
        
        NSString *createDate = [set stringForColumn:@"createDate"];
        NSString *userid = [set stringForColumn:@"userid"];
        NSString *firstUsername = [set stringForColumn:@"firstUsername"];
        NSString *firstname = [set stringForColumn:@"firstname"];
        NSString *icon = [set stringForColumn:@"icon"];
        NSString *iconUpdateTime = [set stringForColumn:@"iconUpdateTime"];
        NSString *isGroupArticle = [set stringForColumn:@"isGroupArticle"];
        NSString *recvId = [set stringForColumn:@"recvId"];
        NSString *typeId = [set stringForColumn:@"typeId"];
        
        NSString *uid = [set stringForColumn:@"uid"];
        
        
        model.articleId = articleId;
        model.context = context;
        model.creatDate = createDate;
        model.userId = userid;
        model.firstUsername = firstUsername;
        model.firstname = firstname;
        model.icon = icon;
        model.iconUpdateTime = iconUpdateTime;
        model.isGroupArticle = isGroupArticle;
        model.recvId = recvId;
        model.typeId = typeId;
        model.uid = uid;
        
        
        if (attachId.length) {
           // NSLog(@"---attachId:%@,fileurl:%@",attachId,fileurl);
            if ([fileurl hasSuffix:@".amr"]) {
               // NSLog(@"---》查询个数＋＋语言");
                model.sendType = SEND_Type_voice;
            }else{
               // NSLog(@"---》查询个数＋＋图片");
                model.sendType = SEND_Type_photo;
            }
            
            VChatAttachModel *att = [[VChatAttachModel alloc] init];
            att.attachId = attachId;
            att.filename = filename;
            att.fileurl = fileurl;
            att.voiceLength = voiceLength;
            [model.attachlist addObject:att];
            
            SSRCRelease(att)
            
        }else{
            model.sendType = SEND_Type_content;
        }
        
        
       // NSLog(@"---》查询个数＋＋");
        [datas addObject:model];
        
        SSRCRelease(model)
    }
    
   // NSLog(@"%d:%sdb:sqlite---%d",__LINE__,__func__,[datas count]);
    return datas;
}
//
+ (void)updateInbase:(NSString *)table withData:(id)object
{
    NSString *ukey = GET_U_ID;
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
    }else{
        NSString *updateSqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?  WHERE %@ = ? AND %@ = ?",
                                                 TABLE_HD,
                                                 @"isRead",
                                                 @"ukey",//用户自身标识 ---根据用户缓存数据
                                                 @"articleId"
                                                 ];
       res = [dataBase executeUpdate:updateSqlString,@"1",ukey,[NSString stringWithFormat:@"%d",[object articleId]]];
        if (res){

        }else{

        }
    }
}

// 读取数据库中的信息
+ (NSInteger)readDataCount:(NSString *)table query:(NSDictionary *)dic{
    NSInteger count = 0;
    NSString *isGroupArticle = [dic objectForKey:@"isGroupArticle"];
    NSString *recvId = [dic objectForKey:@"recvId"];
    NSString *typeId = [dic objectForKey:@"typeId"];
    
    NSString *articleId = [dic objectForKey:@"articleId"];
    NSString *ukey = GET_U_ID;
    
    if (!ukey || !isGroupArticle || !recvId || !typeId || !articleId) {
        return count;
    }
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];//
    BOOL res = [dataBase open];
    if (!res) {
        //  NSLog(@"数据库打开失败");
        return 0;
    }
    NSString *sql = nil;
    FMResultSet *set = nil;
    
    if ([typeId isEqualToString:@"10"]) {
        //私聊
        NSString *userId = ukey;
        // 最大的id降序开始查起
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND ((%@ = ? AND %@ = ?) OR (%@ = ? AND %@ = ?)) ORDER BY %@ DESC ",table,@"ukey",@"isGroupArticle",@"typeId",@"recvId",@"userId",@"recvId",@"userId",@"articleId"];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,typeId,recvId,userId,userId,recvId];
        }
    }
    // 聊天广场
    else if ([typeId isEqualToString:@"9"]){
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? ORDER BY %@ DESC ",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId"];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId];
        }
        
    }
    // 群组聊天
    else{
        if ([articleId isEqualToString:@"0"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ? AND %@ = ? ORDER BY %@ DESC ",table,@"ukey",@"isGroupArticle",@"recvId",@"typeId",@"articleId"];
            set = [dataBase executeQuery:sql,ukey,isGroupArticle,recvId,typeId];
        }
    }
    
    //NSLog(@"sql --- >data数据:%@",sql);
    while ([set next]) {
        count++;
    }
    return count;
}
+ (void)deleteData:(NSString *)table andArticleId:(NSInteger)articleId
{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];
    NSString *uid = GET_U_ID;
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        return;
    }
    else{
        NSString *delSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ?",TABLE_HD,@"ukey",@"articleId"];
        BOOL set = [dataBase executeUpdate:delSql,uid,[NSString stringWithFormat:@"%d",articleId]];
        if (set){

        }else{
        }
    }

}
+ (BOOL)isInDataBase:(NSString *)hdid{
    NSString *uid = GET_U_ID;
    BOOL isin = NO;
    if (hdid && uid) {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteBase querAndCreatChateMessageDatabasePath]];
        BOOL res = [dataBase open];
        if (!res) {
            NSAssert(!res, @"数据库打开失败");
        }else{
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?",TABLE_HD,@"ukey",@"articleId"];
            FMResultSet *set = [dataBase executeQuery:sql,uid,hdid];
            if ([set next]){
                isin = NO;
            }else{
                isin = YES;
            }
        }
    }
    return isin;
}
@end
