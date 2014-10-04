//
//  ChatRecordVoiceView.h
//  EnglishApp
//
//  Created by Ming Zhang on 13-10-31.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRecordVoiceView : UIView
@property (SSRCAutoIdRetainOrStrong, nonatomic) UIImageView *peakMeterIV;

@property (SSRCAutoIdRetainOrStrong, nonatomic) UIImageView *trashCanIV;

@property (SSRCAutoIdRetainOrStrong, nonatomic) UIImageView *recordView;


@property (SSRCAutoIdRetainOrStrong, nonatomic) UILabel *countDownLabel;

//还原界面
- (void)restoreDisplay;

//是否准备删除
- (void)prepareToDelete:(BOOL)_preareDelete;

//是否摇晃垃圾桶
- (void)rockTrashCan:(BOOL)_isTure;

//更新音频峰值
- (void)updateMetersByAvgPower:(float)_avgPower;
@end
