//
//  AddGroupMemberViewController.h
//  UNITOA
//
//  Created by qidi on 14-7-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGroupMemberTableViewCell.h"
#import "MBProgressHUD.h"
@interface AddGroupMemberViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CheckBoxDelegate,MBProgressHUDDelegate>
@property(nonatomic, strong)NSString *groupId;
@property(nonatomic, strong)NSString *groupName;
@property(nonatomic, assign)NSInteger flag;
@end
