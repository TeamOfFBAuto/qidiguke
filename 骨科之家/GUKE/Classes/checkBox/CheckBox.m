//
//  CheckBox.m
//  WeiTongShi
//
//  Created by qidi on 14-5-27.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CheckBox.h"
#define CHECK_ICON_WH                    (15.0)
#define ICON_TITLE_MARGIN                (5.0)
@implementation CheckBox

@synthesize delegate = _delegate;
@synthesize checked = _checked;
@synthesize userInfo = _userInfo;

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        self.exclusiveTouch = YES;
        [self setImage:[UIImage imageNamed:@"userlogin_yes_bg_ico.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"userlogin_yes_ico.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - CHECK_ICON_WH)/2.0, CHECK_ICON_WH, CHECK_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CHECK_ICON_WH + ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - CHECK_ICON_WH - ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

@end
