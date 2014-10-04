//
//  MyLabel.m
//  UNITOA
//
//  Created by ianMac on 14-8-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MyLabel.h"
#define FONTSIZE 13
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
@implementation MyLabel
@synthesize verticalAlignment = verticalAlignment_;
// 设置换行模式,字体大小,背景色,文字颜色,开启与用户交互功能,设置label行数,0为不限制
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.verticalAlignment = VerticalAlignmentMiddle;
        [self setLineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
        [self setFont:[UIFont systemFontOfSize:FONTSIZE]];
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setTextColor:COLOR(59,136,195,1.0)];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
    }
    return self;
}

// 点击该label的时候, 来个高亮显示
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self setTextColor:[UIColor whiteColor]];
//}
// 还原label颜色,获取手指离开屏幕时的坐标点, 在label范围内的话就可以触发自定义的操作
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self setTextColor:COLOR(59,136,195,1.0)];
    UITouch *touch = [touches anyObject];
    CGPoint points = [touch locationInView:self];
    if (points.x >= 0&&points.y >= 0&&points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    {
        [_delegate myLabel:self touchesWtihTag:self.tag];
    }
}


- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.x += 5;
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
