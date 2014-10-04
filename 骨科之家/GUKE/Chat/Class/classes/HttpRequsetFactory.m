//
//  HttpRequsetFactory.m
//  VColleagueChat
//
//  Created by lqy on 4/29/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "HttpRequsetFactory.h"
@implementation HttpRequsetFactory
+(NSMutableDictionary *)requestCommon{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefaults objectForKey:ACCESS_TOKEN_K];
    id u_id = [userDefaults objectForKey:U_ID];
    if (access_token && u_id) {
        [dic setValue:access_token forKey:@"sid"];
        [dic setValue:u_id forKey:@"userId"];
    }
    return [dic autorelease];
}
+ (ASIFormDataRequest *)getRequestKeys:(NSDictionary *)keyDic subUrl:(NSString *)suburl userCommon:(BOOL)con{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GLOBAL_URL,suburl]];
   // NSLog(@"%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSMutableDictionary *dic = nil;
    if (con) {
        dic = [[self class] requestCommon];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    // 将keyDic中的数据转到dic中
    for (NSString *key in keyDic.allKeys) {
        [dic setObject:[keyDic objectForKey:key] forKey:key];
    }
    
    // 发送post请求
    for (NSString *key in dic) {
        [request setPostValue:[dic objectForKey:key] forKey:key];
    }
    return request;
}
@end
