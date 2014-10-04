//
//  SingleInstance.h
//  WeiTongShi
//
//  Created by qidi on 14-6-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SingleInstance : NSObject<AVAudioPlayerDelegate>
{
    NSMutableArray *_objecAarray;
    AVAudioPlayer *avAudioPlayer;   //播放器player
    NSString *_sendId;
    NSString *_recvId;
    BOOL isPush;
}
@property(nonatomic, assign )NSInteger articleId;
@property(nonatomic, strong)NSString *sendId;
@property(nonatomic, strong)NSString *recvId;
@property(nonatomic, assign)BOOL isPush;
@property(nonatomic, strong)NSMutableArray *objecAarray;
+ (instancetype)shareManager;
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
//+ (CGFloat)customHeight:(NSString *)content;
+ (NSString *)handleDate:(NSString *)createDate;
+ (CGFloat)customHeight:(NSInteger)memberCount andcount:(NSInteger)count andsingleHeight:(CGFloat)height;

+ (CGFloat)customFontHeightFont:(NSString *)content andFontSize:(CGFloat)fontSize andLineWidth:(CGFloat)width;
- (void)playVoice;
@end
