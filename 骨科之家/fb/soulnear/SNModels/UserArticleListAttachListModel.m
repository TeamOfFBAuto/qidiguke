//
//  UserArticleListAttachListModel.m
//  GUKE
//
//  Created by soulnear on 14-10-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserArticleListAttachListModel.h"

@implementation UserArticleListAttachListModel
@synthesize articleId  =_articleId;
@synthesize attachId = _attachId;
@synthesize fileurl = _fileurl;
@synthesize filesize = _filesize;

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _articleId = [dic objectForKey:@"articleId"];
        _attachId = [dic objectForKey:@"attachId"];
        _fileurl = [dic objectForKey:@"fileurl"];
        _filesize = [dic objectForKey:@"filesize"];
    }
    
    
    return self;
}






@end
