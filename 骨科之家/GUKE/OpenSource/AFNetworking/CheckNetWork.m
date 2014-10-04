//
//  CheckNetWork.m
//  Notes
//
//  Created by ian on 14-4-17.
//  Copyright (c) 2014年 Joel. All rights reserved.
//

#import "CheckNetWork.h"

@implementation CheckNetWork
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self retain];
    }
    return  self;
}
//即时查看网络状况
- (void)networkTips
{
    Reachability *tekuba_net = [Reachability reachabilityForInternetConnection];
    switch ([tekuba_net currentReachabilityStatus])
    {
        case NotReachable:
        {
            UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"网络故障" message:@"无网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            [self performSelector:@selector(dismissAlertView:) withObject:alart afterDelay:3];
            [alart release];
        }
            break;
        case ReachableViaWWAN:{
            UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前为3G/2G模式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            [self performSelector:@selector(dismissAlertView:) withObject:alart afterDelay:2];
            [alart release];
        }
            break;
        case ReachableViaWiFi:
            break;
        default:
            break;
    }
}

- (void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

//监测网络变化
- (void)checkNetworkChange
{
    //监测网络状态变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //网络是否链接
    Reachability *wifiReach = [Reachability reachabilityForLocalWiFi];
    //,包括蜂窝网络和WIFI
    [wifiReach startNotifier];
    
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    static UIAlertView *alart;
    switch (status) {
        case 0: //无连接
        {
            if (alart.tag != 10) {
                [alart dismissWithClickedButtonIndex:0 animated:NO];
                [alart release];
                alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alart.tag = 10;
                [alart show];
            }
        }
            break;
        case 1: //WIFI
        {
//            if(alart.tag != 11)
//            {
//                [alart dismissWithClickedButtonIndex:0 animated:NO];
//                [alart release];
//                alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前网络为WiFi模式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                alart.tag = 11;
//                [alart show];
//            }
        }
            break;
        case 2: //3G
        {
//            if(alart.tag != 12)
//            {
//                [alart dismissWithClickedButtonIndex:0 animated:NO];
//                [alart release];
//                alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前网络为3G/2G模式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                alart.tag = 12;
//                [alart show];
//            }
        }
            break;
        default:
            break;
    }
}



@end
