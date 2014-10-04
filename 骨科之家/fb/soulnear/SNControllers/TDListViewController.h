//
//  TDDetailViewController.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

/*
 **主题讨论列表页
 */

#import <UIKit/UIKit.h>

@interface TDListViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    
}

@property(nonatomic,strong)PullTableView * myTableView;

@property(nonatomic,strong)NSString * typeId;

@end
