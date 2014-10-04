//
//  SNTools.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface SNTools : NSObject

///时间转换，输入2014-09-10 10：20：21 返回09：10
+(NSString *)dateFromString:(NSString *)dateString;

///弹出一个提示浮层，1.5秒后自动消失
+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;
///弹出浮动层，不自动隐藏
+ (MBProgressHUD *)returnMBProgressWithText:(NSString *)text addToView:(UIView *)aView;
///返回一个NSUrl
+(NSURL *)returnUrl:(NSString *)url;
///返回字符串宽度高度
+(CGSize)returnStringHeightWith:(NSString *)string WithWidth:(float)theWidht WithFont:(int)aFont;
///判断是否为声音
+(BOOL)judgeFileSuffixVoice:(NSString *)string;
///判断是否为图片
+(BOOL)judgeFileSuffixImage:(NSString *)string;





@end























