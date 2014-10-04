//
//  getAppInfo.m
//  UNITOA
//
//  Created by qidi on 14-8-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "getAppInfo.h"
#import "Interface.h"
#import "AlertTableStruct.h"
#define GET_APPIFO_URL @"http://itunes.apple.com/lookup"
@implementation getAppInfo
+ (void)getAppVersion{
     NSString *URLTmp = @"http://itunes.apple.com/lookup?id=916459637";
    NSString *URLTmp1 = [URLTmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
    URLTmp = URLTmp1;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *results = [[resultDic objectForKey:@"results"] firstObject];
        //NSLog(@"%@",results);
        NSString *version = [results objectForKey:@"version"];
        //float fileSizeBytes = [[results objectForKey:@"fileSizeBytes"] floatValue]/1024/1024;
        
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        if (![localVersion isEqualToString:version]) {
//            NSString *alertcontext = LOCALIZATION(@"update_new");
//            NSString *alertText = LOCALIZATION(@"dialog_prompt");
//            NSString *alertOk = LOCALIZATION(@"dialog_ok");
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:[NSString stringWithFormat:@"%@%.2fMB",alertcontext,fileSizeBytes] delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    [operation start];
}
+ (void)getDataBaseVersion:(NSInteger)newVersion
{
     NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)       objectAtIndex:0]stringByAppendingPathComponent:@"dabaseVersion.txt"];
     NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath:plistPath]) {
        [fileManage createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSUInteger oldNum = [[NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil] intValue];
    if (oldNum == newVersion) {
        return;
    }
    else{
        for (int i = oldNum + 1; i <= newVersion; i++) {
            [AlertTableStruct creatTableStruct:newVersion];
        }
    }
    [[NSString stringWithFormat:@"%d",newVersion] writeToFile:plistPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
