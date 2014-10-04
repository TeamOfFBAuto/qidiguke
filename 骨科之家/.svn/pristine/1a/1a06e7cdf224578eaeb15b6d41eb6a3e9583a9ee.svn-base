//
//  AppInPhone.m
//  UNITOA
//
//  Created by qidi on 14-7-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AppInPhone.h"

@implementation AppInPhone
+ (void)telInPhone:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", urlStr]];
    [[UIApplication sharedApplication] openURL:url];
}
+ (void)smsInPhone:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", urlStr]];
    [[UIApplication sharedApplication] openURL:url];
}
+ (void)mailInPhone:(NSString *)urlStr{
    
}
@end
