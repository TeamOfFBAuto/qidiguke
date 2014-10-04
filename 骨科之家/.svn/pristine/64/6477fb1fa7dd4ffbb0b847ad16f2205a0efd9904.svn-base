//
//  Toolbar.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-20.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//
#define defaultToolbarHeight 50.0f
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HPGrowingTextView.h"
#define kbt_tag_toolbar 98772
#define textView_tag_toolbar 1024
@protocol ToolbarDelegate;
@interface Toolbar : UIView
@property (nonatomic,assign) id <ToolbarDelegate> delegate;
- (void)show;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withValidHeight:(CGFloat)height;
- (void)hide;

+ (AppDelegate *)getAppDelegate;
+ (UIView *)getTopView;
@end


@protocol ToolbarDelegate <NSObject>

// 定义toolbar的代理方法（五个）
@optional
- (BOOL)placeTextViewShouldReturn:(HPGrowingTextView *)textView;
- (void)toolBarPicture;

- (void)toolView:(Toolbar *)textView index:(NSInteger)index;

// 触发录音事件
- (void)recordStartQiDi;

// 结束录音事件
- (void)recordEndQiDi;

//should change frame
- (void)toolViewDidChangeFrame:(Toolbar *)textView;
- (void)changeFrame;

@end