//
//  ChatRecordVoiceView.m
//  EnglishApp
//
//  Created by Ming Zhang on 13-10-31.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import "ChatRecordVoiceView.h"
#import <QuartzCore/QuartzCore.h>
#define kTrashImage1         [UIImage imageNamed:@"none.png"]
#define kTrashImage2         [UIImage imageNamed:@"none.png"]
#define kTrashImage3         [UIImage imageNamed:@"none.png"]

@interface ChatRecordVoiceView(){
    NSMutableArray         *peakImageAry;
    NSMutableArray         *trashImageAry;
    BOOL            isPrepareDelete;
    BOOL            isTrashCanRocking;
}

@end

@implementation ChatRecordVoiceView

- (void)dealloc {
//    [peakImageAry release];
//    [trashImageAry release];
//    [_peakMeterIV release];
//    [_trashCanIV release];
//    [_countDownLabel release];
//    [super dealloc];
    
    SSRCRelease(peakImageAry);
    SSRCRelease(trashImageAry);
    SSRCRelease(_peakMeterIV);
    SSRCRelease(_trashCanIV);
    SSRCRelease(_countDownLabel);
    SSRCRelease(_recordView);
    SSRCSuperDealloc;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"====1");
        [self layoutView];
        [self initilization];
    }
    return self;
}

- (void)layoutView{
    self.frame = CGRectMake(0, 0, 160, 160);
    self.backgroundColor = RGBA(0, 0, 0, .4);
    
    _recordView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 30, 135/2, 229/2)];
    _recordView.image = [UIImage imageNamed:@"voice_rcd_hint_new.png"];
    [self addSubview:_recordView];
    
    _peakMeterIV = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-106/2)/2+30+20+5, (self.bounds.size.height-186/2)/2, 66/2, 218/2)] ;
    [self addSubview:_peakMeterIV];
}
/*
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"====2");
        [self initilization];
    }
    return self;
}
 */
- (void)initilization{
    //初始化音量peak峰值图片数组
    self.layer.cornerRadius = 5;
//    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    peakImageAry = SSRCReturnRetained([NSMutableArray array]);
    for (int i = 0; i < 8; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"amp%d_new",i+1]];
        if (image) {
            [peakImageAry addObject:image];
        }else{
            [peakImageAry addObject:[NSNull null]];
        }
    }
    
}



#pragma mark -还原显示界面
- (void)restoreDisplay{
    //还原录音图
    _peakMeterIV.image = [peakImageAry objectAtIndex:0];
    //停止震动
    [self rockTrashCan:NO];
    //还原倒计时文本
    _countDownLabel.text = @"";
}

#pragma mark - 是否准备删除
- (void)prepareToDelete:(BOOL)_preareDelete{
    if (_preareDelete != isPrepareDelete) {
        isPrepareDelete = _preareDelete;
        [self rockTrashCan:isPrepareDelete];
    }
}
#pragma mark - 是否摇晃垃圾桶
- (void)rockTrashCan:(BOOL)_isTure{
    if (_isTure != isTrashCanRocking) {
        isTrashCanRocking = _isTure;
        if (isTrashCanRocking) {
            //摇晃
            _trashCanIV.animationImages = trashImageAry;
            _trashCanIV.animationRepeatCount = 0;
            _trashCanIV.animationDuration = 1;
            [_trashCanIV startAnimating];
        }else{
            //停止
            if (_trashCanIV.isAnimating)
                [_trashCanIV stopAnimating];
            _trashCanIV.animationImages = nil;
            _trashCanIV.image = kTrashImage1;
        }
    }
}
#pragma mark - 更新音频峰值
- (void)updateMetersByAvgPower:(float)_avgPower{
    //-160表示完全安静，0表示最大输入值
    //
    
    /*
    NSInteger imageIndex = 0;
    if (_avgPower >= -40 && _avgPower < -30)
        imageIndex = 1;
    else if (_avgPower >= -30 && _avgPower < -25)
        imageIndex = 2;
    else if (_avgPower >= -25)
        imageIndex = 3;
    _peakMeterIV.image = [peakImageAry objectAtIndex:imageIndex];
     */
    
    NSInteger imageIndex = 0;
    if (_avgPower >= -50 && _avgPower < -40)
        imageIndex = 1;
    else if (_avgPower >= -40 && _avgPower < -25)
        imageIndex = 2;
    else if (_avgPower >= -25 && _avgPower < -20)
        imageIndex = 3;
    else if (_avgPower >= -20 && _avgPower < -15)
        imageIndex = 5;
    else if (_avgPower >= -15 && _avgPower < -10)
        imageIndex = 6;
    else if (_avgPower >= -10)
        imageIndex = 7;
    if (imageIndex > peakImageAry.count-1) {
        imageIndex = peakImageAry.count-1;
    }
    _peakMeterIV.image = [peakImageAry objectAtIndex:imageIndex];
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
