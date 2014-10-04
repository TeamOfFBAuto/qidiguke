//
//  UIImage+UIImageExt.h
//  Starway
//
//  Created by Ming Zhang on 13-7-24.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>//
@interface UIImage (UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageByScalingAndCroppingUpForSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingOrgSize:(CGSize)targetSize;

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height ;
@end
