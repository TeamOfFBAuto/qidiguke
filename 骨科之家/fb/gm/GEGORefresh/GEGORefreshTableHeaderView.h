//
//  GEGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormGEGO. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SCGIFImageView;

typedef enum{
	GEGOOPullRefreshPulling = 0,
	GEGOOPullRefreshNormal,
	GEGOOPullRefreshLoading,	
} GEGOPullRefreshState;

typedef enum{  
  GEGORefreshHeader = 0,  
  GEGORefreshFooter      
} GEGORefreshPos;  

@protocol GEGORefreshTableDelegate;
@interface GEGORefreshTableHeaderView : UIView {
	
	id _delegate;
	GEGOPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <GEGORefreshTableDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)GEGORefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)GEGORefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)GEGORefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setState:(GEGOPullRefreshState)aState;

@end
@protocol GEGORefreshTableDelegate
- (void)GEGORefreshTableDidTriggerRefresh:(GEGORefreshPos)aRefreshPos;  
- (BOOL)GEGORefreshTableDataSourceIsLoading:(UIView*)view;  
@optional  
- (NSDate*)GEGORefreshTableDataSourceLastUpdated:(UIView*)view;  
@end
