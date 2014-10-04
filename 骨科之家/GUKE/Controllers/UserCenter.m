//
//  UserCenter.m
//  VColleagueChat
//
//  Created by Ming Zhang on 14-5-25.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import "UserCenter.h"
#import "HttpRequsetFactory.h"
#import "Interface.h"
@interface UserCenter(){
     
}
@end
@implementation UserCenter

static UserCenter *instance;
+ (UserCenter *)sharedClientCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserCenter alloc] init];
    });
    return instance;
}


- (void)uploadDeviceToken:(NSData *)data{
    NSData *dev = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (dev) {
        [dic setObject:dev forKey:@"deviceToken"];
        ASIFormDataRequest *httpRequest = [HttpRequsetFactory getRequestKeys:dic subUrl:SUB_URL_UPLOADTOKEN userCommon:YES];
        [httpRequest setDelegate:self];
        [httpRequest setDidFailSelector:@selector(fail:)];
        [httpRequest setDidFinishSelector:@selector(finish:)];
        [httpRequest startAsynchronous];
    }
}
- (void)fail:(ASIHTTPRequest *)request{
    self.uploadDeviceToken = NO;
}
- (void)finish:(ASIHTTPRequest *)request{
    NSLog(@"as----%@,%@",request.responseData,request.responseString);
    NSString *response = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    SSRCAutorelease(response);
    
    NSDictionary *dic = [request.responseString objectFromJSONString ];
    //    [self getContactLists:(nsmutabled)];
    NSLog(@"请求返回:%@",dic);
    if (request.responseStatusCode == 200 && [[NSString stringWithFormat:@"%@",[dic objectForKey:CKEY]]isEqualToString:SUC_CKEY]){
        self.uploadDeviceToken = YES;
    }else{
        self.uploadDeviceToken = NO;
    }
}
@end
