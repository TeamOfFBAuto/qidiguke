//
//  RSSwitch.m
//  VColleagueChat
//
//  Created by lqy on 4/22/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "RSSwitch.h"
@interface RSSwitch(){
    UIButton *_frontButton;
    UIButton *_backButton;
}

#if ! __has_feature(objc_arc)
@property (nonatomic,retain) UIImage *leftNormal;
@property (nonatomic,retain) UIImage *leftSelect;

@property (nonatomic,retain) UIImage *rightNormal;
@property (nonatomic,retain) UIImage *rightSelect;
#else

@property (nonatomic,strong) UIImage *leftNormal;
@property (nonatomic,strong) UIImage *leftSelect;

@property (nonatomic,strong) UIImage *rightNormal;
@property (nonatomic,strong) UIImage *rightSelect;

#endif
@end
@implementation RSSwitch
#if ! __has_feature(objc_arc)
- (void)dealloc{
    self.leftNormal = nil;
    self.leftSelect = nil;
    self.rightNormal = nil;
    self.rightSelect = nil;
    self.switchSelcet = nil;
    [super dealloc];
}
#endif
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame leftNormal:(NSString *)left leftSelect:(NSString *)leftSelct rightNormal:(NSString *)rightNormal rightSelect:(NSString *)rightSelect{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame leftImgNormal:(UIImage *)left leftImgSelect:(UIImage *)leftSelct rightImgNormal:(UIImage *)rightNormal rightImgSelect:(UIImage *)rightSelect{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftNormal = left;
        self.leftSelect = leftSelct;
        self.rightNormal = rightNormal;
        self.rightSelect = rightSelect;
        [self initialization];
    }
    return self;
    
}
#if ! __has_feature(objc_arc)
//- (instancetype)initWithFrame:(CGRect)frame leftNormal:(NSString *)left leftSelect:(NSString *)leftSelct rightNormal:(NSString *)rightNormal rightSelect:(NSString *)rightSelect{
//    return nil;
//}
#else



#endif


- (void)initialization{
    if (!_frontButton) {
        _frontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _frontButton.frame = CGRectMake(0, 0, (self.bounds.size.width / 2.0f), self.bounds.size.height);
        [self addSubview:_frontButton];
        [_frontButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_frontButton setTitle:@"x" forState:UIControlStateNormal];
        _frontButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake((self.bounds.size.width / 2.0f), 0, (self.bounds.size.width / 2.0f), self.bounds.size.height);
        [self addSubview:_backButton];
        [_backButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_backButton setTitle:@"右边" forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    
    [self setSwitchTag:0];
    self.backgroundColor = [UIColor clearColor];
}
- (void)btnClick:(UIButton *)sender{
    if (sender == _frontButton) {
        self.switchTag = 0;
    }else{
        self.switchTag = 1;
    }

    if (_switchSelcet) {
        _switchSelcet(_switchTag);
    }
}

- (void)setSwitchTag:(NSInteger)switchTag{
    _switchTag = switchTag;
    
    if (switchTag == 0) {
        [self selectFont:YES];
    }else{
        [self selectFont:NO];
    }
}
- (void)selectFont:(BOOL)selfont{
    if (selfont) {
        [_frontButton setBackgroundImage:_leftSelect forState:UIControlStateNormal];
        [_backButton setBackgroundImage:_rightNormal forState:UIControlStateNormal];
        
        [_frontButton setBackgroundImage:_leftSelect forState:UIControlStateHighlighted];
        [_backButton setBackgroundImage:_rightNormal forState:UIControlStateHighlighted];
    }else{
        [_frontButton setBackgroundImage:_leftNormal forState:UIControlStateNormal];
        [_backButton setBackgroundImage:_rightSelect forState:UIControlStateNormal];
        
        [_frontButton setBackgroundImage:_leftNormal forState:UIControlStateHighlighted];
        [_backButton setBackgroundImage:_rightSelect forState:UIControlStateHighlighted];
    }
}

- (void)setLeftTilte:(NSString *)title lColor:(UIColor *)lcolor RightTitle:(NSString *)rTitle rColor:(UIColor *)rcolor{
    [_frontButton setTitle:title forState:UIControlStateNormal];
    [_frontButton setTitleColor:lcolor forState:UIControlStateNormal];
    
    [_backButton setTitle:rTitle forState:UIControlStateNormal];
    [_backButton setTitleColor:rcolor forState:UIControlStateNormal];
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
