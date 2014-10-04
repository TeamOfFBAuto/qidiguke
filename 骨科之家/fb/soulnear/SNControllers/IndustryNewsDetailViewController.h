//
//  IndustryNewsDetailViewController.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//


/*
 **动态新闻正文
 */
#import <UIKit/UIKit.h>



@interface NewsDetailModel : NSObject
{
    
}

@property(nonatomic,strong)NSString * attachId;
@property(nonatomic,strong)NSString * dongtaiId;
@property(nonatomic,strong)NSString * filename;
@property(nonatomic,strong)NSString * filesize;
@property(nonatomic,strong)NSString * fileurl;


-(id)initWithDic:(NSDictionary *)dic;

@end



@interface IndustryNewsDetailViewController : SNViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property(nonatomic,strong)NSString * theId;

@end
