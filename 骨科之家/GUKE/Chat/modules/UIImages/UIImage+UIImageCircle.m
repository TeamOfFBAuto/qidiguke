//
//  UIImage+UIImageCircle.m
//  Starway
//
//  Created by Ming Zhang on 13-7-26.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import "UIImage+UIImageCircle.h"

@implementation UIImage (UIImageCircle)
-(UIImage *)imageCircleWithBoderWidth:(CGFloat)boder withShadow:(CGFloat)shadow{
    UIImage *finalImage = nil;
    UIGraphicsBeginImageContext(self.size);
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGAffineTransform trnsfrm = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, -1.0));
        trnsfrm = CGAffineTransformConcat(trnsfrm, CGAffineTransformMakeTranslation(0.0, self.size.height));
        CGContextConcatCTM(ctx, trnsfrm);
        CGContextBeginPath(ctx);
        CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, self.size.width, self.size.height));
        CGContextClip(ctx);
        CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, self.size.width, self.size.height), self.CGImage);
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return finalImage;
}
-(UIImage *)imageCircle{
    UIImage *finalImage = nil;
    UIGraphicsBeginImageContext(self.size);
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGAffineTransform trnsfrm = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, -1.0));
        trnsfrm = CGAffineTransformConcat(trnsfrm, CGAffineTransformMakeTranslation(0.0, self.size.height));
        CGContextConcatCTM(ctx, trnsfrm);
        CGContextBeginPath(ctx);
        CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, self.size.width, self.size.height));
        CGContextClip(ctx);
        CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, self.size.width, self.size.height), self.CGImage);
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return finalImage;
}
@end
