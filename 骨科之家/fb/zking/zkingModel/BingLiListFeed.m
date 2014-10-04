//
//  BingLiListFeed.m
//  GUKE
//
//  Created by szk on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "BingLiListFeed.h"


@implementation AttachListFeed

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.attachId = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"attachId"]]];
        self.filename = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filename"]]];
        self.fileurl = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"fileurl"]]];
    }
    return self;
}

@end

@implementation TagListFeed

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.tagId = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"tagId"]]];
        self.tag = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"tag"]]];
        self.userId = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]]];
        self.bingliId = [NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bingliId"]]];
    }
    return self;
}

@end



@implementation BingLiListFeed


-(void)setBingLiListFeedDic:(NSDictionary *)mydic{

    self.bingliId=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"bingliId"]]];
    
    self.userId=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"userId"]]];
    
    self.psnname=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"psnname"]]];
    
    self.sex=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"sex"]]];
    
    self.zhenduan=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"zhenduan"]]];

    self.mobile=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"mobile"]]];
    
    self.relateMobile=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"relateMobile"]]];
    
    self.fangan=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"fangan"]]];
    
    self.binglihao=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"binglihao"]]];
    
    self.leibieId=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"leibieId"]]];
    
    self.idno=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"idno"]]];
    
    self.jiuzhen=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"jiuzhen"]]];
    
    self.bianma=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"bianma"]]];
    
    self.memo=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"memo"]]];
    
    self.fenleiId=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"fenleiId"]]];
    
    self.createDate=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"createDate"]]];
    
    self.leibiename=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"leibiename"]]];
    
    self.fenleiname=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"fenleiName"]]];
    
    self.firstname=[NSString _859ToUTF8:[NSString stringWithFormat:@"%@",[mydic objectForKey:@"firstname"]]];
    
    NSArray * array = [mydic objectForKey:@"attachlist"];

    self.attach_array = [NSMutableArray arrayWithArray:array];
    
    self.tag_array = [NSMutableArray array];
    
    NSArray * array1 = [mydic objectForKey:@"taglist"];
        
    for (NSDictionary * aDic in array1) {
        TagListFeed * alFeed = [[TagListFeed alloc] initWithDic:aDic];
        [self.tag_array addObject:alFeed];
    }
}


@end






























