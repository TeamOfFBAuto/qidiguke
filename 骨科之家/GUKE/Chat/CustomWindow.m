//
//  CustomWindow.m
//  VColleagueChat
//
//  Created by lqy on 4/23/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"nScreenTouch" object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"data"]]];
    }
    [super sendEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
