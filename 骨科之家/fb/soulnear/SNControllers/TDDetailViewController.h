//
//  TDDetailViewController.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//
/*
 **主题讨论正文页
 */

#import <UIKit/UIKit.h>
#import "TDListModel.h"
#import "ChatVoiceRecorderVC.h"

@interface TDDetailViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
}

@property(nonatomic,strong)TDListModel * info;

@property(nonatomic,strong)UITableView * myTableVIEW;
@property(nonatomic,strong)ChatVoiceRecorderVC * recorderVC;
@end
