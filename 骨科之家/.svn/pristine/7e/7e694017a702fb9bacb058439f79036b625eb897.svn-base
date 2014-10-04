//
//  WindowCustom.m
//  UNITOA
//
//  Created by qidi on 14-9-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "WindowCustom.h"

@implementation WindowCustom
{
    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // timer = [NSTimer alloc]initWithFireDate:nil interval:60 target:self selector:@selector(<#selector#>) userInfo:<#(id)#> repeats:<#(BOOL)#>
    }
    return self;
}
-(void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"nScreenTouch" object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"data"]]];
    }
   // [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:nil userInfo:nil repeats:YES];
    [super sendEvent:event];
    //NSLog(@"dscdsfvdsf");
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
