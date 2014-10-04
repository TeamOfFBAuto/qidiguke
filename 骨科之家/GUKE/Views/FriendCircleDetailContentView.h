//
//  FriendCircleDetailContentView.h
//  UNITOA
//  个人朋友圈的内容的View
//  Created by ianMac on 14-9-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCircleDetailContentViewCell.h"
#import "MyLabel.h"
#import "FBCirclePicturesViews.h"

@protocol  FriendCircleDetailContentViewDelegate<NSObject>


@end


@interface FriendCircleDetailContentView : UIView<UITableViewDataSource,UITableViewDelegate,MyLabelDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *contentDataArray;
@property(nonatomic,assign)id<FriendCircleDetailContentViewDelegate>delegate;
+ (CGFloat)heightForCellWithPost:(NSMutableArray *)dataArray;

@end
