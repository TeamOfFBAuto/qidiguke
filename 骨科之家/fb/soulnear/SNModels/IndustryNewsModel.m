//
//  IndustryNewsModel.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "IndustryNewsModel.h"

@implementation IndustryNewsModel
@synthesize content = _content;
@synthesize smallPic = _smallPic;
@synthesize dongtaiId = _dongtaiId;
@synthesize createDate = _createDate;
@synthesize weight = _weight;
@synthesize title = _title;

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _content = [dic objectForKey:@"content"];
        _smallPic = [dic objectForKey:@"smallPic"];
        _dongtaiId = [dic objectForKey:@"dongtaiId"];
        _createDate = [dic objectForKey:@"createDate"];
        _weight = [dic objectForKey:@"weight"];
        _title = [dic objectForKey:@"title"];
    }
    return self;
}
























@end
