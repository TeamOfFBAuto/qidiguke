//
//  TopicDiscussViewController.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//
/*
 **主题讨论
 */

#import <UIKit/UIKit.h>

@interface TopicDiscussViewController : SNViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>
{
    
}
@property(nonatomic,strong)PullTableView * myTableView;




@end
