//
//  SingleInstance.m
//  WeiTongShi
//
//  Created by qidi on 14-6-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SingleInstance.h"

@implementation SingleInstance
+ (instancetype)shareManager
{
    static SingleInstance * _shareManager = nil;
    static dispatch_once_t _shareTocken;
    dispatch_once(&_shareTocken, ^{
        _shareManager = [[self alloc]init];
        _shareManager.isPush = NO;
        _shareManager.recvId = nil;
        _shareManager.sendId = nil;
        
    });
    return _shareManager;
}
// RGB 颜色值
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
// 自适应高度
+ (CGFloat)customFontHeightFont:(NSString *)content andFontSize:(CGFloat)fontSize andLineWidth:(CGFloat)width
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:fontSize];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize sizeText = CGSizeMake(0, 0);
    if (IOS7_LATER) {
        sizeText = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else{
        CGSize size = CGSizeMake(width,MAXFLOAT);
        sizeText = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    CGFloat height = sizeText.height;
    return height;
}
// 自适应高度
+ (CGSize)customFontHeight:(NSString *)content andFontSize:(CGFloat)fontSize andLineWidth:(CGFloat)width
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:fontSize];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize sizeText = CGSizeMake(0, 0);
    if (IOS7_LATER) {
        sizeText = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else{
        CGSize size = CGSizeMake(width,MAXFLOAT);
        sizeText = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    return sizeText;
}
// 时间处理函数
+ (NSString *)handleDate:(NSString *)createDate
{
    NSString *subDate = [[createDate componentsSeparatedByString:@" "] firstObject];
    NSArray *mouthAndDay = [subDate componentsSeparatedByString:@"-"];
    NSString *mouth = mouthAndDay[1];
    NSString *day = mouthAndDay[2];
    if ([mouth hasPrefix:@"0"]) {
        mouth = [mouth substringWithRange:NSMakeRange(1, 1)];
    }
    if ([day hasPrefix:@"0"] ) {
        day = [day substringWithRange:NSMakeRange(1, 1)];
    }
    
    return [NSString stringWithFormat:@"%@月%@日",mouth,day];
}

// 动态确定collectionView的高度
+ (CGFloat)customHeight:(NSInteger)memberCount andcount:(NSInteger)count andsingleHeight:(CGFloat)height{
    NSInteger i = 0;
    if (memberCount % count == 0) {
        i = memberCount/count;
    }
    else{
        i = memberCount/count + 1;
    }
    return height * i;
}
- (void)playVoice{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"newdatatoast" ofType:@"wav"];
         //把音频文件转换成url格式
         NSURL *url = [NSURL fileURLWithPath:string];
         //初始化音频类 并且添加播放文件
         avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
         //设置代理
         avAudioPlayer.delegate = self;
    
         //设置初始音量大小
        // avAudioPlayer.volume = 1;
    
         //设置音乐播放次数  -1为一直循环
         avAudioPlayer.numberOfLoops = 0;
    
         //预播放
         [avAudioPlayer play];
}

@end
