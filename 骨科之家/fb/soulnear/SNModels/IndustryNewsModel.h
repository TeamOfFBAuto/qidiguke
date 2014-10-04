//
//  IndustryNewsModel.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndustryNewsModel : NSObject
{
    
}

///业界动态详细内容
@property(nonatomic,strong)NSString * content;
///创建日期
@property(nonatomic,strong)NSString * createDate;
///id
@property(nonatomic,strong)NSString * dongtaiId;
///小图片
@property(nonatomic,strong)NSString * smallPic;
///weight
@property(nonatomic,strong)NSString * weight;
///标题
@property(nonatomic,strong)NSString * title;



-(id)initWithDic:(NSDictionary *)dic;


@end
