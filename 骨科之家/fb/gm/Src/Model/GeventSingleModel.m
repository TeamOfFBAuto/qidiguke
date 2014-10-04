//
//  GeventSingleModel.m
//  GUKE
//
//  Created by gaomeng on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GeventSingleModel.h"

@implementation GeventSingleModel

+ (GeventSingleModel *)sharedManager
{
    static GeventSingleModel *GeventSingleModelInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        GeventSingleModelInstance = [[self alloc] init];
        GeventSingleModelInstance.eventDateDicArray = [NSMutableArray arrayWithCapacity:1];
    });
    return GeventSingleModelInstance;
}


@end
