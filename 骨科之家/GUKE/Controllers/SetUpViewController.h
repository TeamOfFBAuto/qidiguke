//
//  SetUpViewController.h
//  WeiTongShi
//
//  Created by qidi on 14-6-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PrivatPoliceViewController.h"
#import "MBButtonMenuViewController.h"
@interface SetUpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBButtonMenuViewControllerDelegate>
@property (nonatomic, strong) MBButtonMenuViewController *menu1;// UIActionSheet1
@end
