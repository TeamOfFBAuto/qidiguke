//
//  TagManagerViewController.h
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingLiListFeed.h"

@interface TagManagerViewController : SNViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)BingLiListFeed * myFeed;

@property(nonatomic,strong)NSMutableArray * data_array;

@end
