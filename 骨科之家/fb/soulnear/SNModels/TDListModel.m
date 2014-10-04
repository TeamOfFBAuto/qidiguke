//
//  TDListModel.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TDListModel.h"

@implementation TDListModel
@synthesize zhutiId = _zhutiId;
@synthesize typeId = _typeId;
@synthesize title = _title;
@synthesize psnname = _psnname;
@synthesize content = _content;
@synthesize smallPic = _smallPic;
@synthesize bigPic = _bigPic;
@synthesize createDate = _createDate;



-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _zhutiId = [NSString _859ToUTF8:[dic objectForKey:@"zhutiId"]];
        _typeId = [NSString _859ToUTF8:[dic objectForKey:@"typeId"]];
        _title = [NSString _859ToUTF8:[dic objectForKey:@"title"]];
        _psnname = [NSString _859ToUTF8:[dic objectForKey:@"psnname"]];
        _content = [NSString _859ToUTF8:[dic objectForKey:@"content"]];
        _smallPic = [NSString _859ToUTF8:[dic objectForKey:@"smallPic"]];
        _bigPic = [NSString _859ToUTF8:[dic objectForKey:@"bigPic"]];
        _createDate = [NSString _859ToUTF8:[dic objectForKey:@"createDate"]];
    }
    
    return self;
}



@end
