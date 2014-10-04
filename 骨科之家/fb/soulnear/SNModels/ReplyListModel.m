//
//  AttachListModel.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ReplyListModel.h"

@implementation ReplyListModel
@synthesize context = _context;
@synthesize firstname = _firstname;
@synthesize replyId = _replyId;
@synthesize createDate = _createDate;
@synthesize userId = _userId;
@synthesize zhutiId = _zhutiId;
@synthesize attach_array = _attach_array;
@synthesize theType = _theType;


-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _context = [NSString _859ToUTF8:[dic objectForKey:@"context"]];
        _firstname = [NSString _859ToUTF8:[dic objectForKey:@"firstname"]];
        _replyId = [NSString _859ToUTF8:[dic objectForKey:@"replyId"]];
        _createDate = [NSString _859ToUTF8:[dic objectForKey:@"sendTime"]];
        _userId = [NSString _859ToUTF8:[dic objectForKey:@"userId"]];
        _zhutiId = [NSString _859ToUTF8:[dic objectForKey:@"zhutiId"]];
        
        _attach_array = [NSMutableArray array];
        
        NSArray * array = [dic objectForKey:@"attachlist"];
        if ([array isKindOfClass:[NSArray class]])
        {
            for (NSDictionary * dic1 in array)
            {
                AttachListModel * model = [[AttachListModel alloc] initWithDic:dic1];
                [_attach_array addObject:model];
            }
        }
        
        if ([_attach_array count]) {
            AttachListModel *fir = [_attach_array firstObject];
            NSString *attach1 = fir.filename;
            if (attach1) {
                if ([attach1 hasSuffix:@".amr"]) {
                    _theType = SEND_Type_voice;
                    
                }else{
                    _theType = SEND_Type_photo;
                }
            }else{
                _theType = SEND_Type_other;
            }
        }else{
            
            _theType = SEND_Type_content;
        }
    }
    return self;
}


@end































