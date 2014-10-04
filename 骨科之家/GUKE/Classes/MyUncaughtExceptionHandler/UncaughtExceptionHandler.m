//
//  UncaughtExceptionHandler.m
//  UNITOA
//
//  Created by qidi on 14-7-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#import "Interface.h"
#include <execinfo.h>
void InstallUncaughtExceptionHandler();
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
@implementation UncaughtExceptionHandler
+ (NSArray *)backtrace

{
    
    void* callstack[128];
    
    int frames = backtrace(callstack, 128);
    
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (
         
         i = UncaughtExceptionHandlerSkipAddressCount;
         
         i < UncaughtExceptionHandlerSkipAddressCount +
         
         UncaughtExceptionHandlerReportAddressCount;
         
         i++)
        
    {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
        
    }
    
    free(strs);
    
    return backtrace;
    
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex

{
    
    if (anIndex == 0)
        
    {
        
        dismissed = YES;
        
    }
    
}
//- (void)creatErrorFile:(NSString *)content
//{
////NSError *error;
//    NSString *folderPath = [DOCUMENTPATH stringByAppendingPathComponent:@"ErrorFolder"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];   
//    NSString * path = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.log",@"thunisoacrash",@"12"]];
//    // 如果文件不存在，则创建
//    if(![fileManager fileExistsAtPath:path]){
//        BOOL res = [fileManager createFileAtPath:path contents:nil attributes:nil];
//        if (res) {
//            NSAssert(res, @"创建文件失败 ");
//        }
//        
//    }
//    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@",path);
//    NSData *fileData = [NSData dataWithContentsOfFile:path];
//    [AFRequestService responseDataWithFile:CRASH_REPORT andparameters:nil andImageData:fileData andfieldType:@"file" andfileName:[NSString stringWithFormat:@"%@-%@.log",@"thunisoacrash",[NSDate date]] andMimeType:@"application/log" andResponseData:^(NSData *responseData) {
//        
//    }];
//}
- (void)handleException:(NSException *)exception

{
   
    NSString * url = [NSString stringWithFormat:NSLocalizedString(@"%@\n%@\n%@", nil),
                      [exception name],
                      [exception reason],
                      [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    // 写入到文件
   //[self creatErrorFile:url];
    NSLog(@"crash_reason=====%@",url);

    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);	
    
    while (!dismissed)
        
    {
        
        for (NSString *mode in (__bridge NSArray *)allModes)
            
        {
            
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
            
        }
        
    }	
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    
    signal(SIGILL, SIG_DFL);
    
    signal(SIGSEGV, SIG_DFL);
    
    signal(SIGFPE, SIG_DFL);
    
    signal(SIGBUS, SIG_DFL);
    
    signal(SIGPIPE, SIG_DFL);	
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
        
    {
        
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
        
    }
    
    else
        
    {
        
        [exception raise];
        
    }
    
}
@end
      NSString* getAppInfo()
      
    {
        
        NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                             
                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                             
                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                             
                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                             
                             [UIDevice currentDevice].model,
                             
                             [UIDevice currentDevice].systemName,
                             
                             [UIDevice currentDevice].systemVersion
                             
                             ];
        
        NSLog(@"Crash!!!! %@", appInfo);
        
        return appInfo;
        
    }
      
      void MySignalHandler(int signal)
      
    {
        
        int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
        
        if (exceptionCount > UncaughtExceptionMaximum)
            
        {
            
            return;
            
        }
        
        NSMutableDictionary *userInfo =
        
        [NSMutableDictionary
         
         dictionaryWithObject:[NSNumber numberWithInt:signal]
         
         forKey:UncaughtExceptionHandlerSignalKey];
        
        NSArray *callStack = [UncaughtExceptionHandler backtrace];
        
        [userInfo
         
         setObject:callStack
         
         forKey:UncaughtExceptionHandlerAddressesKey];
        
        [[[UncaughtExceptionHandler alloc] init]
         
         performSelectorOnMainThread:@selector(handleException:)
         
         withObject:
         
         [NSException
          
          exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
          
          reason:
          
          [NSString stringWithFormat:
           
           NSLocalizedString(@"Signal %d was raised.\n"
                             
                             @"%@", nil),
           
           signal, getAppInfo()]
          
          userInfo:
          
          [NSDictionary
           
           dictionaryWithObject:[NSNumber numberWithInt:signal]
           
           forKey:UncaughtExceptionHandlerSignalKey]]
         
         waitUntilDone:YES];
        
    }
      
      void InstallUncaughtExceptionHandler()
      
    {
        
        signal(SIGABRT, MySignalHandler);
        
        signal(SIGILL, MySignalHandler);
        
        signal(SIGSEGV, MySignalHandler);
        
        signal(SIGFPE, MySignalHandler);
        
        signal(SIGBUS, MySignalHandler);
        
        signal(SIGPIPE, MySignalHandler);
        
    }
