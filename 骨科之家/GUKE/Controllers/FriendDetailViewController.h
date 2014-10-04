//
//  FriendDetailViewController.h
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SqliteFieldAndTable.h"
#import "AppDelegate.h"
#import "FriendIfo.h"
@interface FriendDetailViewController : UIViewController<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic, strong)FriendIfo *friendModel;


- (instancetype)initWithUserId:(NSString *)userId;
@end
