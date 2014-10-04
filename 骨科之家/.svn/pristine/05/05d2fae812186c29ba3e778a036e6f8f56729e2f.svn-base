//
//  FriendContentView.h
//  UNITOA
//
//  Created by qidi on 14-8-7.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserArticleList.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"
//#import "RTLabel.h"
#import "MyLabel.h"


#define USER_ICON_WHDTH 40.0
#define USER_ICON_HEIGHT 40.0

#define USER_NAME_WHDTH 60.0
#define USER_NAME_HEIGHT 20.0

#define URL_LABEL_WHDTH 200.0
#define URL_LABEL_HEIGHT 20.0

#define SHARE_IMAGE_WHDTH 225.0
#define SHARE_IMAGE_HEIGHT 165.0

#define REPORT_TIME_WHDTH 100.0
#define REPORT_TIME_HEIGHT 20.0

#define FAVORITE_WHDTH 60.0
#define FAVORITE_HEIGHT 40.0

#define COMMENT_WHDTH 60.0
#define COMMENT_HEIGHT 40.0

#define USER_ARTI_LIST @"user_article_list"
#define FAVORIT_DEFAULT_TAG 1024
#define COMMENT_DEFAULT_TAG 10240
#define COMMENT_ID_TAG 65535
#define ACTIONSHEET_BG_TAG 501
#define ACTIONSHEET_SHARE_TAG 502
#define USER_ICON_CELL_TAG 999
#define IMG_TAG 99999


#define SHARE_BG_WIGHT 256
#define ICO_HEIGHT 30
#define ICO_WIGHT 30
#define SINGLE_GOOD_COUNT 5
#define SAME2_TAG 999999
// 每次请求刷新的条数
#define REFRESH_COUNT 5
@interface FriendContentView : UIView<UIActionSheetDelegate,MyLabelDelegate>
@property(nonatomic, assign)UIImage *shareImage;
@property (nonatomic, strong)MyLabel *contact;
@property(nonatomic, strong)UIImageView *shareImg;
@property(nonatomic, strong)UserArticleList *articleModel;
@property(nonatomic, assign)BOOL isShareLabel;
+ (CGFloat)heightForCellWithPost:(UserArticleList *)articleModel;
@end
