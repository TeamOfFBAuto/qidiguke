//
//  PerferencesInfo.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-18.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#ifndef VColleagueChat_PerferencesInfo_h
#define VColleagueChat_PerferencesInfo_h


//screen
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//color
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IsIOS7 ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

/*
 信息是否发送成功
 */
// 已发出
#define ISSEND @"0"
// 未发出
#define ISNOSENT @"1"

//font
#define FONT_ARIAL(size1) [UIFont fontWithName:@"Arial" size:size1]

//date
#define DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_UUID @"yyyyMMddHHmmss"
#define DATE_FORMAT_YYMMDD @"yyyy-MM-dd"

//png jpg图片读取
#define K_contentsOfFilePNG(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]
#define K_contentsOfFileJPG(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"]


// sys path
//path
#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]//文档路径

#define GET_U_ID [[NSUserDefaults standardUserDefaults] objectForKey:U_ID]
#define GET_U_NAME [[NSUserDefaults standardUserDefaults] objectForKey:U_NAME]
#define GET_U_ICON [[NSUserDefaults standardUserDefaults] objectForKey:U_PHOTO]
#define GET_GROUPID [[NSUserDefaults standardUserDefaults] objectForKey:GROUP_ID]
#endif
