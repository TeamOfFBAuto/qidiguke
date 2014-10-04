//
//  GroupsViewController.h
//  GUKE
//
//  Created by soulnear on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



@interface SNGroupsViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    
}


///分享类型0：病历库 1：资料库
@property(nonatomic,strong)NSString * type;
///病历库或资料库id
@property(nonatomic,strong)NSString * theId;










@end
