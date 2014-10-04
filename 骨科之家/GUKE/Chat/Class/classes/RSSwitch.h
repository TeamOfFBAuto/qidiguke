//
//  RSSwitch.h
//  VColleagueChat
//
//  Created by lqy on 4/22/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//
//
#import <UIKit/UIKit.h>
typedef void (^ RSSwitchSelect) (NSInteger);
@interface RSSwitch : UIView
- (id)initWithFrame:(CGRect)frame leftNormal:(NSString *)left leftSelect:(NSString *)leftSelct rightNormal:(NSString *)rightNormal rightSelect:(NSString *)rightSelect;

- (id)initWithFrame:(CGRect)frame leftImgNormal:(UIImage *)left leftImgSelect:(UIImage *)leftSelct rightImgNormal:(UIImage *)rightNormal rightImgSelect:(UIImage *)rightSelect;

- (void)setLeftTilte:(NSString *)title lColor:(UIColor *)lcolor RightTitle:(NSString *)rTitle rColor:(UIColor *)rcolor;


@property (nonatomic) NSInteger switchTag;
@property (nonatomic,copy) RSSwitchSelect switchSelcet;
@end
