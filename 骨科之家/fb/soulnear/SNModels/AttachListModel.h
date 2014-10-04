//
//  AttachListModel.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//
/*
 **评论内容数据类
 */
#import <Foundation/Foundation.h>




@interface AttachListModel : NSObject
{
    
}


@property(nonatomic,strong)NSString * attachId;
@property(nonatomic,strong)NSString * filename;
@property(nonatomic,strong)NSString * fileurl;
@property(nonatomic,strong)NSString * replyId;
@property(nonatomic,strong)NSString * voiceLength;

-(id)initWithDic:(NSDictionary *)dic;




@end
