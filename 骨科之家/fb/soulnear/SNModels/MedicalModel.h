//
//  MedicalModel.h
//  GUKE
//
//  Created by soulnear on 14-10-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalModel : NSObject
///姓名
@property(nonatomic,strong)NSString * userName;
///年龄
@property(nonatomic,strong)NSString * userAge;
///就诊时间
@property(nonatomic,strong)NSString * date;
///诊断
@property(nonatomic,strong)NSString * zhenduan;
///病人手机号
@property(nonatomic,strong)NSString * patient_phone_num;
///家属手机号
@property(nonatomic,strong)NSString * family_phone_num;
///病历号
@property(nonatomic,strong)NSString * patient_num;
///身份证号
@property(nonatomic,strong)NSString * card_num;
///标记编码
@property(nonatomic,strong)NSString * mark_code;



@end






















