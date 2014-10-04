//
//  NSString+_859ToUTF8.m
//  GUKE
//
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "NSString+_859ToUTF8.h"

@implementation NSString (_859ToUTF8)
+ (NSString *)_859ToUTF8:(NSString *)oldStr
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    
    return [NSString stringWithUTF8String:[oldStr cStringUsingEncoding:enc]];
}

@end
