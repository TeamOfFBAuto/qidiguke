//
//  UserArticleListAttachListModel.h
//  GUKE
//
//  Created by soulnear on 14-10-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//
/*
 **诊疗圈存放多文件数据类型
 */
#import <Foundation/Foundation.h>
///诊疗圈存放多文件数据类型
@interface UserArticleListAttachListModel : NSObject
{
    
}

@property(nonatomic,strong)NSString * articleId;
@property(nonatomic,strong)NSString * attachId;
@property(nonatomic,strong)NSString * filesize;
@property(nonatomic,strong)NSString * fileurl;

-(id)initWithDic:(NSDictionary *)dic;


@end
