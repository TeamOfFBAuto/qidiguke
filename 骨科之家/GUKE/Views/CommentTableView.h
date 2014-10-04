//
//  CommentTableView.h
//  UNITOA
//
//  Created by qidi on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentTableViewCell.h"
typedef void(^CommentBlock)(NSString *);
@interface CommentTableView : UIView<UITableViewDataSource,UITableViewDelegate,RTLabelDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *commentArray;
@property(nonatomic, copy)CommentBlock blockAction;
@end
