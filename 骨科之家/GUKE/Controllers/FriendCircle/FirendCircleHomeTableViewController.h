//
//  FirendCircleHomeTableViewController.h
//  诊疗圈
//
//  Created by qidi on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FriendCircleContentTableViewCell.h"
#import "MBButtonMenuViewController.h"
#import "FriendCircleTableViewCell.h"
#import "HPGrowingTextView.h"
#import "FriendCircleHomeTableViewCell.h"
#import "ELCImagePickerController.h"
@interface FirendCircleHomeTableViewController : UITableViewController<UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HPGrowingTextViewDelegate,MBProgressHUDDelegate,MBButtonMenuViewControllerDelegate,RTLabelDelegate,UITextViewDelegate,FriendCircleHomeTableViewCellDelegate,ELCImagePickerControllerDelegate>
@property (nonatomic, strong) MBButtonMenuViewController *menu1;// UIActionSheet1
@property (nonatomic, strong) MBButtonMenuViewController *menu2;// UIActionSheet2
@end
