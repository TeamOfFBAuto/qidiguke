//
//  ChooseCaseTypeViewController.h
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//
/*
 **选择病历分类
 */
#import <UIKit/UIKit.h>
#import "BingLiListFeed.h"

@interface ChooseCaseTypeViewController : SNViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)BingLiListFeed * feed;

@property(nonatomic,strong)NSMutableArray * delete_array;

@end
