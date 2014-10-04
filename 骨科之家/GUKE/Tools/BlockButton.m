//
//  BlockButton.m
//  Matters
//
//  Created by ianMac on 14-7-6.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickAction
{
    self.block(self);
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
