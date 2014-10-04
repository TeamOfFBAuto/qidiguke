//
//  BlockButton.h
//  Matters
//
//  Created by ianMac on 14-7-6.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlockButton;
typedef void(^TouchBlock)(BlockButton *);

@interface BlockButton : UIButton

@property (nonatomic, copy) TouchBlock block;
@end
