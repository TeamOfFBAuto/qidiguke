//
//  MyLabel.h
//  UNITOA
//
//  Created by ianMac on 14-8-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class MyLabel;
@protocol MyLabelDelegate <NSObject>
@required
- (void)myLabel:(MyLabel *)myLabel touchesWtihTag:(NSInteger)tag;
@end
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface MyLabel : UILabel
{
    VerticalAlignment _verticalAlignment;
}
@property (nonatomic, assign) id <MyLabelDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
