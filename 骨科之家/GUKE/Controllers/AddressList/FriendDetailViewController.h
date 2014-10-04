//
//  FriendDetailViewController.h
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendIfo.h"
@interface FriendDetailViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic, strong)FriendIfo *friendModel;
@end
