//
//  GroupMemberListViewController.h
//  UNITOA
//
//  Created by qidi on 14-7-9.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupList.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@interface GroupMemberListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic, strong)GroupList *groupModel;
@property (nonatomic, strong)NSMutableArray *groupMemberList;
@property (nonatomic, retain) UICollectionView *collectionView;//使用UICollectionView进行布局
@end
