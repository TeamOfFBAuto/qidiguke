//
//  SqliteClass.m
//  UNITOA
//
//  Created by qidi on 14-7-22.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SqliteClass.h"
#define DATABASE_FOLDER  @"database_folder"
#define DATABASE_NAME    @"thunis.db"
@implementation SqliteClass
// 穿件数据库文件夹
+(NSString *)dataBaseFoler{
    NSError *error;
    NSString *folderPath = [DOCUMENTPATH stringByAppendingPathComponent:DATABASE_FOLDER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:folderPath]){
        BOOL res = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(res, @"创建目录失败 ");
    }
    NSLog(@"%@",folderPath);
    return folderPath;
}
// 获取数据库的路径
+(NSString *)querAndCreatDatabasePath{
    return [[self dataBaseFoler] stringByAppendingPathComponent:DATABASE_NAME];
}

+ (FMDatabase *)creatDataBase:(NSString *)table andkeyArray:(NSArray *)key{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[SqliteClass querAndCreatDatabasePath]];
    
    BOOL res = [dataBase open];
    if (!res) {
        NSAssert(!res, @"数据库打开失败");
        return nil;
    }
    NSString *sqlC = nil;
    NSString *feild = nil;
    NSString *feildsi = @"";
    NSString *values = @"";
    NSMutableArray *value = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [key count]; i++)
    {
        if (i) {
           
            feild = [feild stringByAppendingString:[NSString stringWithFormat:@",%@ varchar",[key objectAtIndex:i]]];
            feildsi = [feildsi stringByAppendingString:[NSString stringWithFormat:@",%@",[key objectAtIndex:i]]];
            values = [values stringByAppendingString:@",?"];
        }
        else{
            feild = [NSString stringWithFormat:@"%@ varchar",[key objectAtIndex:i]];
            feildsi = [NSString stringWithFormat:@"%@",[key objectAtIndex:i]];
            values = @"?";
        }
        [value addObject:[key objectAtIndex:i]];
    }
    
    sqlC = [NSString stringWithFormat:@"CREATE TABLE %@(%@)",table,feild];
    [dataBase executeUpdate:sqlC];
    return dataBase;
}
@end
