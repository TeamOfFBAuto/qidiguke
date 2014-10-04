//
//  AppDelegate.m
//  UNITOA
//
//  Created by qidi on 14-6-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "UserContactViewController.h"
#import "FriendListViewController.h"
#import "FirendCircleHomeTableViewController.h"
#import "SqliteFieldAndTable.h"
#import "MyUncaughtExceptionHandler.h"
#import "UncaughtExceptionHandler.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserCenter.h"
#import "Interface.h"
#import "CheckNetWork.h"
#import "addNewContact.h"
#import "getAppInfo.h"

@implementation AppDelegate

// 调用InstallUncaughtExceptionHandler() 
- (void)installUncaughtExceptionHandler

{
    
    InstallUncaughtExceptionHandler();
    
}
// 注册远程推送通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 存储远程推送通知的tocken值
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:DEVICETOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison0"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"ison1"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison2"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison3"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison4"];
    }else{
        NSLog(@"不是第一次启动");
    }
    self.window = [[WindowCustom alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    /* 数据库的版本升级，当前版本是2*/
    [getAppInfo getDataBaseVersion:2];
    
    /* 获取版本信息，检查是否有更新*/
    [getAppInfo getAppVersion];
    
    /* 多语言的切换*/
    NSUserDefaults *lanUser = [NSUserDefaults standardUserDefaults];
    NSString *lan = [lanUser objectForKey:@"LAN"];
    if (NULL == lan) {
        lan = @"zh";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:lan ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(NULL != dictionary){
        [lanUser setObject:dictionary forKey:@"language"];
    }

    // 聊天页面
   
    /*
     页面跳转的部分 如果是点击推送消息启动的程序，则跳到指定的页面
     如果不是点击推送启动的程序，则正常启动程序
     */
    if (launchOptions != nil && ![launchOptions isEqual:[NSNull null]]) {
        [[NSUserDefaults standardUserDefaults] setValue:launchOptions forKey:LANUCH];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showControlView:Root_contact];
        
    }
    else{
     //自动登入的判断
    if (IS_AUTOLOG && GET_USER_ID != nil && GET_S_ID !=nil) {
        [self showControlView:Root_contact];
    }
    else{
        [self showControlView:Root_login];
    }
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //注册远程推送通知
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
   
    
    // 监测网络
    CheckNetWork *check = [[CheckNetWork alloc] init];
    [check checkNetworkChange];
    [check networkTips];
    
    // 异常的捕获
    [MyUncaughtExceptionHandler setDefaultHandler];
    //[self installUncaughtExceptionHandler];
    return YES;
}

// 接受（到）远程推送通知（挂起）
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSDictionary *dic = [userInfo objectForKey:@"info"];
    NSString *typeid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"typeId"]];
    // 发送人的id
    NSString *dataId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dataId"]];
    // 接受人的id
    NSString *recvId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recvId"]];
    // 私人聊天
    [[SingleInstance shareManager] setRecvId:recvId];
    [[SingleInstance shareManager] setSendId:dataId];
    [[SingleInstance shareManager] setIsPush:YES];
    [[NSUserDefaults standardUserDefaults] setObject:dataId forKey:@"sendId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([typeid isEqualToString:PUSH_PCHAT]) {
        [[NSUserDefaults standardUserDefaults] setObject:dataId forKey:@"dataId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([recvId isEqualToString:GET_USER_ID]) {
                [addNewContact addUserContact:dataId];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushNewPChat object:nil userInfo:nil];
    }
    // 全部的消息推送
    if ([typeid isEqualToString:PUSH_PCHAT] || [typeid isEqualToString:PUSH_GPCHAT] || [typeid isEqualToString:PUSH_GCHAT]){
        if ([typeid isEqualToString:PUSH_PCHAT]){
            NSString *recvId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dataId"]];
            // 私人聊天
            [[SingleInstance shareManager] setRecvId:recvId];
        }
        if (([typeid isEqualToString:PUSH_GPCHAT] || [typeid isEqualToString:PUSH_GCHAT])&& [[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"] boolValue] == NO) {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redLabel" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NEW object:nil userInfo:dic];
    }
    // 聊天广场
    if ([typeid isEqualToString:PUSH_GCHAT] ) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"] boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushNewGChat object:nil userInfo:nil];
        }
    }
    // 群聊
    if ([typeid isEqualToString:PUSH_GPCHAT] ) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"]boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushNewGPChat object:nil userInfo:nil];
        }
        
    }
    
    // 如果当前用户是接受者，则走此方法
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self playVoice];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                });
            });
    
    
}
- (void)playVoice{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newdatatoast" ofType:@"wav"];
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison1"]boolValue]) {
        AudioServicesPlaySystemSound(soundID);
    }
    else{
    AudioServicesDisposeSystemSoundID(soundID);
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison2"]boolValue]) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else{
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    }
}
// 控制视图的跳转
- (void)showControlView:(ROOTVC_TYPE)type
{
    if (type == Root_login){
        UserLoginViewController *vc = [[UserLoginViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        if (IOS7_LATER) {
            nv.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.window.rootViewController = nv;
        
    }else if (type == Root_home){
        // 更新tocken值
        // 把tocken写到服务器
        if ([[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] != nil && ![[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] isEqual:[NSNull null]]) {
            NSDictionary *params = @{@"userId": GET_USER_ID,@"sid":GET_S_ID,@"deviceToken":[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN]};
            [AFRequestService responseData:UPLOAD_TOCKEN_URL andparameters:params  andResponseData:^(NSData *responseData) {
                NSDictionary *dict = (NSDictionary *)responseData;
                NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
                if (codeNum == CODE_SUCCESS) {
                    return ;
                }
                else if (codeNum == CODE_ERROE){
                    SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                    AppDelegate __weak *_Self = self;
                    [sqliteAndtable repeatLogin:^(BOOL flag) {
                        if (flag) {
                            [_Self showControlView:Root_home];
                            
                        }
                        else{
                            [_Self showControlView:Root_login];
                        }
                        
                    }];
                }
            }];
        }
        // 后台执行加载数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            [sqliteAndtable getAllInfo];
            sqliteAndtable = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                
            });
        });
        
        FriendListViewController *vc = [[FriendListViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nv;
    }else if (type == Root_contact){
        // 后台执行加载数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            [sqliteAndtable getAllInfo];
            sqliteAndtable = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                
            });
        });
         UserContactViewController *userContact = [[UserContactViewController alloc]init];
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:userContact];
        //标记是否是推送过去的
        userContact.index = 1;
        if (IOS7_LATER) {
            nvc.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.window.rootViewController = nvc;
    }
    else if(type == Root_friend){
        FriendListViewController *vc = [[FriendListViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nv;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:ENTERFORGROUD object:nil userInfo:nil];
        
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
