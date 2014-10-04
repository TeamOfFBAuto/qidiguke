//
//  CheckBox.h
//  WeiTongShi
//
//  Created by qidi on 14-5-27.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CheckBoxDelegate;
@interface CheckBox : UIButton
{
    id<CheckBoxDelegate> _delegate;
    BOOL _checked;
    id _userInfo;
}
@property(nonatomic, strong)id<CheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, strong)id userInfo;
- (id)initWithDelegate:(id)delegate;
@end
@protocol CheckBoxDelegate <NSObject>
- (void)didSelectedCheckBox:(CheckBox *)checkbox checked:(BOOL)checked;
@end