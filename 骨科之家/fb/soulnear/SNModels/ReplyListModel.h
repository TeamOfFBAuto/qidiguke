//
//  AttachListModel.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

/*
 **评论列表数据类
 */

#import <Foundation/Foundation.h>
#import "AttachListModel.h"

typedef enum{
    SEND_Type_content = 0,
    SEND_Type_photo,
    SEND_Type_voice,
    SEND_Type_other,
}COMMENT_TYPE;

@interface ReplyListModel : NSObject
@property(nonatomic,strong)NSString * context;
@property(nonatomic,strong)NSString * firstname;
@property(nonatomic,strong)NSString * replyId;
@property(nonatomic,strong)NSString * createDate;
@property(nonatomic,strong)NSString * userId;
@property(nonatomic,strong)NSString * zhutiId;
@property(nonatomic,strong)NSMutableArray * attach_array;
@property(nonatomic,assign)COMMENT_TYPE theType;


-(id)initWithDic:(NSDictionary *)dic;



@end
