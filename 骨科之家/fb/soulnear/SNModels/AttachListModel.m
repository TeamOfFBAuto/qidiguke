//
//  AttachListModel.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AttachListModel.h"

@implementation AttachListModel
@synthesize attachId = _attachId;
@synthesize filename = _filename;
@synthesize fileurl = _fileurl;
@synthesize replyId = _replyId;
@synthesize voiceLength = _voiceLength;

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _attachId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"attachId"]];
        _filename = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filename"]];
        _fileurl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fileurl"]];
        _replyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"replyId"]];
        _voiceLength = [NSString stringWithFormat:@"%@",[dic objectForKey:@"voiceLength"]];
    }
    return self;
}





@end
