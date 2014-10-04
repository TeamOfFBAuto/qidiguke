//
//  GEGORefreshTableFooterView.h
//  Anteater
//
//  Created by 浩 张 on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GEGORefreshTableHeaderView.h"
@class SCGIFImageView;

@interface GEGORefreshTableFooterView : UIView
{
    id _delegate;
	GEGOPullRefreshState _state;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    SCGIFImageView  *loadingView;

}

@property(nonatomic,assign) id <GEGORefreshTableDelegate> delegate;


- (void)refreshLastUpdatedDate;
- (void)GEGORefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)GEGORefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)GEGORefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
