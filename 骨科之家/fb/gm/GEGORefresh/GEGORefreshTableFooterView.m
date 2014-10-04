//
//  GEGORefreshTableFooterView.m
//  Anteater
//
//  Created by 浩 张 on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GEGORefreshTableFooterView.h"

#define  RefreshViewHight 65.0f
#define  TEXT_COLOR	 [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]
#define  FLIP_ANIMATION_DURATION 0.18f

@interface GEGORefreshTableFooterView (Private)
- (void)setState:(GEGOPullRefreshState)aState;
@end

@implementation GEGORefreshTableFooterView
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame: frame];
  if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    
		UILabel *label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f,self.bounds.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:11.0f];
		label.textColor = TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, 20, 16.0f, 31.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blackArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(105.0f, 20, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		[self setState:GEGOOPullRefreshNormal];
		
  }
	
  return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(GEGORefreshTableDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate GEGORefreshTableDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"上午"];
		[formatter setPMSymbol:@"下午"];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
    
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"GEGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
  
}

- (void)setState:(GEGOPullRefreshState)aState{
	
	switch (aState) {
		case GEGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"松开即可更新~", @"松开即可更新~");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case GEGOOPullRefreshNormal:
			
			if (_state == GEGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉即可更新~", @"上拉即可更新~");
			[_activityView stopAnimating];
      _activityView.hidden = YES;
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case GEGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"加载中~", @"加载中~");
			[_activityView startAnimating];
      _activityView.hidden = NO;
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)GEGORefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == GEGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(GEGORefreshTableDataSourceIsLoading:)]) {
			_loading = [_delegate GEGORefreshTableDataSourceIsLoading:self];
		}
		
		if (_state == GEGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:GEGOOPullRefreshNormal];
		} else if (_state == GEGOOPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {
			[self setState:GEGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)GEGORefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(GEGORefreshTableDataSourceIsLoading:)]) {
		_loading = [_delegate GEGORefreshTableDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(GEGORefreshTableDidTriggerRefresh:)]) {
			[_delegate GEGORefreshTableDidTriggerRefresh:GEGORefreshFooter];
		}
		
		[self setState:GEGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
		[UIView commitAnimations];
	}
	
}

//加载完成后调用
- (void)GEGORefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	NSLog(@"ashdasdhjsahj");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:GEGOOPullRefreshNormal];
  
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
  [super dealloc];
}
@end
