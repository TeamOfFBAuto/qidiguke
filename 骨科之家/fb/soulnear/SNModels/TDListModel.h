//
//  TDListModel.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDListModel : NSObject
{
    
}

@property(nonatomic,strong)NSString * zhutiId;
@property(nonatomic,strong)NSString * typeId;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * psnname;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * smallPic;
@property(nonatomic,strong)NSString * bigPic;
@property(nonatomic,strong)NSString * createDate;


-(id)initWithDic:(NSDictionary *)dic;



@end
