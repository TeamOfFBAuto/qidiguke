//
//  PullTableView.h
//  TableViewPull
//
//  Created by Emre Ergenekon on 2011-07-30.
//  Copyright 2011 Kungliga Tekniska Högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInterceptor.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
typedef enum{
	Dragging_upRefresh = 0,//上拉刷新的操作互动界面使用
	Dragging_upLoadmore,//下拉刷新操作
} Dragging_type;
@class PullTableView;
@protocol PullTableViewDelegate <NSObject>

/* After one of the delegate methods is invoked a loading animation is started, to end it use the respective status update property */
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView;
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView;

@end


@interface PullTableView : UITableView <EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate>{
    
    EGORefreshTableHeaderView *refreshView;// 下拉刷新
    LoadMoreTableFooterView *loadMoreView;// 上拉加载更多
    
    // Since we use the contentInsets to manipulate the view we need to store the the content insets originally specified.
    UIEdgeInsets realContentInsets;
    
    // For intercepting the scrollView delegate messages.获取scrollView代理消息
    MessageInterceptor * delegateInterceptor;
    
    // Config
    UIImage *pullArrowImage;
    UIColor *pullBackgroundColor;
    UIColor *pullTextColor;
    NSDate *pullLastRefreshDate;
    
    // Status
    BOOL pullTableIsRefreshing;
    BOOL pullTableIsLoadingMore;
    
    // Delegate
    id<PullTableViewDelegate> pullDelegate;
    
}
//上下拉 
@property (nonatomic,assign)Dragging_type draggingType;
/* The configurable display properties of PullTableView. Set to nil for default values */
@property (nonatomic, retain) UIImage *pullArrowImage;
@property (nonatomic, retain) UIColor *pullBackgroundColor;
@property (nonatomic, retain) UIColor *pullTextColor;

/* Set to nil to hide last modified text */
@property (nonatomic, retain) NSDate *pullLastRefreshDate;

/* Properties to set the status of the refresh/loadMore operations. */
/* After the delegate methods are triggered the respective properties are automatically set to YES. After a refresh/reload is done it is necessary to set the respective property to NO, otherwise the animation won't disappear. You can also set the properties manually to YES to show the animations. */
/*
@property (nonatomic, assign) BOOL pullTableIsRefreshing;
@property (nonatomic, assign) BOOL pullTableIsLoadingMore;
 */
@property (assign,nonatomic) BOOL pullTableIsRefreshing;
@property (assign,nonatomic) BOOL pullTableIsLoadingMore;

/* Delegate */
@property (nonatomic, assign) IBOutlet id<PullTableViewDelegate> pullDelegate;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style with:(Dragging_type)type;
@end
