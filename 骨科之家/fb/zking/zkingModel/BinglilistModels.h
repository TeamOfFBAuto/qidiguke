//
//  BinglilistModel.h
//  GUKE
//
//  Created by szk on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BinglilistModelsBloc)(int errcode ,NSString *info);


@interface BinglilistModels : NSObject

@property(nonatomic,strong)NSString *code;

@property(nonatomic,strong)NSString *page;

@property(nonatomic,strong)NSString *pageCount;//总页数

@property(nonatomic,strong)NSString *recordCount;//总记录数

@property(nonatomic,copy)BinglilistModelsBloc mybloc;


@property(nonatomic,strong)NSMutableArray *feedArr;//放feed


-(void)setBinglilistModelDatawithBloc:(BinglilistModelsBloc)theBloc;



@end
