//
//  APIInfo.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-18.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#ifndef VColleagueChat_APIInfo_h
#define VColleagueChat_APIInfo_h

#define DEVICETOKEN @"deviceToken"
#define LANUCH      @"lanuch"
#define ISARC_HASFAATURE NSLog(@"如果是arc则需要释放")

#define CKEY @"code"
#define SUC_CKEY @"0"

#define CGSIZE_SCALE_MAX CGSizeMake(640, 640)

#define LOG_USER_NAME @"logUserName"
#define LOG_USER_PSW  @"logUserPSW"
#define U_ID @"u_id"
#define ACCESS_TOKEN_K @"access_token_k"
#define U_PHOTO @"photo"
#define U_NAME @"name"
#define GROUP_ID @"groupId"

//#define GLOBAL_URL @"http://thunisoa.931.com/webservices"
//
//#define GLOBAL_URL_FILEGET @"http://thunisoa.931.com/upload"

//#define GLOBAL_URL @"http://unisoa.931.com/webservices"
//
//#define GLOBAL_URL_FILEGET @"http://unisoa.931.com/upload"
// 骨科地址
#define GLOBAL_URL_FILEGET @"http://guke.931.com/upload"// 图片的链接固定部分

#define GLOBAL_URL @"http://guke.931.com/webservices" // 主机地址

/**
 push
 */
// 个人聊天
#define PUSH_PCHAT @"6"
// 聊天广场
#define PUSH_GCHAT @"4"
// 群组聊天
#define PUSH_GPCHAT @"2"

#define PUSH_NEW @"push_new"

#define kPushNewPChat @"kPushNewPChat"
#define kPushNewGChat @"kPushNewGChat"
#define kPushNewGPChat @"kPushNewGPChat"
// 程序从后台启动
#define ENTERFORGROUD @"enterForeground"
/*
 tableview 的拖拽方式
 */
/*通用字段 表示 此程序获取的key值*/
#define DRAGG @"dragg"
/*表示下拉 激活上面的*/
#define DRAG_UP @"updragging"
/*表示上啦 激活下面的*/
#define DRAG_DOWN @"downdragging"

/**
 登录
 */
#define SUB_URL_LOGIN @"/login.php"

/**
 审核通过用户列表
 */
#define SUB_URL_USERLIST @"/userlist.php"


/**
 14、发表公开信及群组信息
 */
#define SUB_URL_NEWARTICLE @"/newarticle.php"

/**
 36、公开信及群组最新信息列表
 */
#define SUB_URL_NERARTICLELIST @"/newarticlelist.php"

/**
 31、用户加入及创建的群组列表
 */
#define SUB_URL_USERADDEDGROUPLIST @"/useraddedgrouplist.php"

/**
 58、用户群组及联系人列表
 */
#define SUB_URL_USERCONTACT @"/usercontact.php"

/**
114、上传用户deviceToken
 */
#define SUB_URL_UPLOADTOKEN @"/uploadtoken.php"


/**
115、V聊最新消息
 */
#define SUB_URL_NEWBOARDARTICLE @"/newboardarticle.php"

#endif






