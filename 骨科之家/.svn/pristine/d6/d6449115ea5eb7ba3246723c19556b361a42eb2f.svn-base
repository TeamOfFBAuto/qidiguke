//
//  RadioButton.h
//  WeiTongShi
//
//  Created by qidi on 14-5-28.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RadioButtonDelegate;
@interface RadioButton : UIButton
{
    NSString                        *_groupId;
    BOOL                            _checked;
    id<RadioButtonDelegate>       _delegate;
}

@property(nonatomic, strong)id<RadioButtonDelegate>   delegate;
@property(nonatomic, strong, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;
@end
@protocol RadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(RadioButton *)radio groupId:(NSString *)groupId;

@end