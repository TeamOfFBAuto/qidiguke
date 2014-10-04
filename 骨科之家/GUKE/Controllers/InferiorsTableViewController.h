//
//  InferiorsTableViewController.h
//  UNITOA
//  下级列表
//  Created by ianMac on 14-8-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InferiorsTableViewController : UITableViewController<UITableViewDataSource>


- (instancetype)initWithDstUserId:(NSString *)dstUserId;
@end
