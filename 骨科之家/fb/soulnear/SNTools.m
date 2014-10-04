//
//  SNTools.m
//  GUKE
//ni
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SNTools.h"

@implementation SNTools

+(NSString *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:destDate];
    return destDateString;
}


+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

+ (MBProgressHUD *)returnMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+(NSURL *)returnUrl:(NSString *)url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]];
}


+(CGSize)returnStringHeightWith:(NSString *)string WithWidth:(float)theWidht WithFont:(int)aFont
{
    CGRect rectr = [string boundingRectWithSize:CGSizeMake(theWidht, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:aFont]} context:nil];
    return rectr.size;
}


// 判断文件的后缀名是否是声音文件
+(BOOL)judgeFileSuffixVoice:(NSString *)string
{
    if ([[string pathExtension]isEqualToString:@"amr"] || [[string pathExtension]isEqualToString:@"wma"] || [[string pathExtension]isEqualToString:@"mp3"]){
        return YES;
    }else{
        return NO;
    }
}

// 判断文件的后缀名是否是图片文件
+(BOOL)judgeFileSuffixImage:(NSString *)string
{
    if ([[string pathExtension]isEqualToString:@"jpg"] || [[string pathExtension]isEqualToString:@"JPG"] || [[string pathExtension]isEqualToString:@"png"] || [[string pathExtension]isEqualToString:@"PNG"] || [[string pathExtension]isEqualToString:@"gif"] || [[string pathExtension]isEqualToString:@"GIF"]) {
        return YES;
    }else{
        return NO;
    }
}


@end














