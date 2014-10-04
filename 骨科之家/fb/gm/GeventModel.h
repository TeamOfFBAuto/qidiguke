//
//  GeventModel.h
//  GUKE
//
//  Created by gaomeng on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeventModel : NSObject

@property(nonatomic,strong)NSString *eventId;
@property(nonatomic,strong)NSString *userId;//发布用户
@property(nonatomic,strong)NSString *eventTitle;//活动标题
@property(nonatomic,strong)NSString *eventTime;//活动时间
@property(nonatomic,strong)NSString *endTime;//报名截止时间
@property(nonatomic,strong)NSString *userLimit;//人数上限
@property(nonatomic,strong)NSString *address;//活动地点
@property(nonatomic,strong)NSString *phone;//联系电话
@property(nonatomic,strong)NSString *fee;//活动费用
@property(nonatomic,strong)NSString *context;//活动内容
@property(nonatomic,strong)NSString *createDate;//发布时间
@property(nonatomic,strong)NSString *userExists;//当前用户是否报名，0：否，1：是"



//初始化方法
-(id)initWithDic:(NSDictionary *)dic;


@end
