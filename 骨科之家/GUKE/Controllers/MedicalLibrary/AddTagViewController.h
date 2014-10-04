//
//  AddTagViewController.h
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingLiListFeed.h"

@interface AddTagViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)BingLiListFeed * feed;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end
