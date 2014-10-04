//
//  BingLiListFeed.h
//  GUKE
//
//  Created by szk on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
///文件数据类
@interface AttachListFeed : NSObject
///文件id
@property(nonatomic,strong)NSString * attachId;
///文件名
@property(nonatomic,strong)NSString * filename;
///文件链接地址
@property(nonatomic,strong)NSString * fileurl;

-(id)initWithDic:(NSDictionary *)dic;

@end

///病例标签
@interface TagListFeed : NSObject

///标签id
@property(nonatomic,strong)NSString * tagId;
///标签内容
@property(nonatomic,strong)NSString * tag;
///病历id
@property(nonatomic,strong)NSString * bingliId;
///用户id
@property(nonatomic,strong)NSString * userId;

-(id)initWithDic:(NSDictionary *)dic;

@end



@interface BingLiListFeed : NSObject
///病历id
@property(nonatomic,strong)NSString * bingliId;
///用户id
@property(nonatomic,strong)NSString * userId;
///姓名
@property(nonatomic,strong)NSString * psnname;
///性别
@property(nonatomic,strong)NSString * sex;
///诊断
@property(nonatomic,strong)NSString * zhenduan;
///病人手机
@property(nonatomic,strong)NSString * mobile;
///家属手机号
@property(nonatomic,strong)NSString * relateMobile;
///治疗方案
@property(nonatomic,strong)NSString * fangan;
///病历号
@property(nonatomic,strong)NSString * binglihao;
///类别id
@property(nonatomic,strong)NSString * leibieId;
///身份证号
@property(nonatomic,strong)NSString * idno;
///就诊时间
@property(nonatomic,strong)NSString * jiuzhen;
///标记编码
@property(nonatomic,strong)NSString * bianma;
///备注说明
@property(nonatomic,strong)NSString * memo;
///分类id
@property(nonatomic,strong)NSString * fenleiId;
///创建时间
@property(nonatomic,strong)NSString * createDate;
///类别名称
@property(nonatomic,strong)NSString * leibiename;
///f分类名称
@property(nonatomic,strong)NSString * fenleiname;
///上传用户名
@property(nonatomic,strong)NSString * firstname;

///文件数据
@property(nonatomic,strong)NSMutableArray * attach_array;
///标签数据
@property(nonatomic,strong)NSMutableArray * tag_array;

-(void)setBingLiListFeedDic:(NSDictionary *)mydic;






@end
