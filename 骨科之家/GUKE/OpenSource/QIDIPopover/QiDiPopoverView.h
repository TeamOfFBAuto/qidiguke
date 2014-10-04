//
//  KWPopoverView.h
//  KWPopoverViewDemo
//
//  Created by zzl on 14-4-10.
//  Copyright (c) 2014年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiDiPopoverView : UIView

+ (void)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;
- (void)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;
- (void)dismiss;
@end
