//
//  FriendCircleHomeTableViewCell.h
//  UNITOA
//
//  Created by qidi on 14-8-6.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "FriendContentView.h"
#import "CommentView.h"
#import "CommentTableView.h"
typedef void(^CommentViewBlock)(NSString *);
@class UserArticleList;
@interface FriendCircleHomeTableViewCell : UITableViewCell<RTLabelDelegate>
@property(nonatomic, strong)UserArticleList *post;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, assign)UIImage *shareImage;
@property(nonatomic, strong)UIImageView *userIcon;
@property(nonatomic, strong)UILabel *userName;
@property(nonatomic, strong)UILabel *content;
@property(nonatomic, strong)UIImageView *shareImg;
@property(nonatomic, strong)UILabel *reportTime;
@property(nonatomic, strong)UIButton *favorite;
@property(nonatomic, strong)UIButton *comment;
@property(nonatomic, strong)UILabel *urlLabel;
@property (nonatomic, strong)RTLabel *contact;
@property (nonatomic, strong)FriendContentView *ContentView;
@property(nonatomic, strong)CommentView *goodView;
@property(nonatomic, strong)CommentTableView *commentView;
@property(nonatomic, copy)CommentViewBlock sendUserId;
+ (CGFloat)heightForCellWithPost:(UserArticleList *)post;
@end
