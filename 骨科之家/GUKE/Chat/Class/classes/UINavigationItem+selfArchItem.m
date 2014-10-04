//
//  UINavigationItem+selfArchItem.m
//  VColleagueChat
//
//  Created by lqy on 4/22/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "UINavigationItem+selfArchItem.h"

@implementation UINavigationItem (selfArchItem)

- (UILabel *)selfArchSetTitle:(NSString *)titel{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:18];
    lab.text = titel;
    lab.textColor = [UIColor whiteColor];
    [self setTitleView:lab];
#if ! __has_feature(objc_arc)
    [lab release];
#endif
    
    return lab;
}

- (void)selfArchSetReturnAnimated:(BOOL)animated Sel:(SEL)sel target:(id)target{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 34);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setBackgroundImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self setLeftBarButtonItem:left animated:animated];
    
#if ! __has_feature(objc_arc)
    [left release];
#endif
}

@end
