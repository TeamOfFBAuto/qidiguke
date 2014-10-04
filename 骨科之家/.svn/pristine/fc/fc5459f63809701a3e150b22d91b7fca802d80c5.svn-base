//
//  UUID.m
//  VColleagueChat
//
//  Created by lqy on 4/24/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "UUID.h"

@implementation UUID
// 创建通用的唯一标示
+ (NSString *)createUUID
{
    
    //   NSString *string = [GetDateFormater getDate:DATE_FORMAT_UUID withDate:[NSDate date]];
    //   return string;
    //   Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    //      Get the string representation of CFUUID object.
    NSString *uuidStr = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject) autorelease];
    
    //   If needed, here is how to get a representation in bytes, returned as a structure
    //   typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   ...
    //   UInt8 byte15;
    // } CFUUIDBytes;
    CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    CFRelease(uuidObject);
    return uuidStr;
}

@end
