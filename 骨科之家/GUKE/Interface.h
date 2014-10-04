//
//  Interface.h
//  WeiTongShi
//
//  Created by qidi on 14-5-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#ifndef WeiTongShi_Interface_h
#define WeiTongShi_Interface_h
#import "SingleInstance.h"
#import "UserIfo.h"
#import "UserInfoDB.h"
#import "AFRequestService.h"
#import "UserDefaultsCatch.h"
#import "UIImageView+WebCache.h"
#import "SNTools.h"
#import "PullTableView.h"
#import "MBProgressHUD.h"
#import "UIImage+UIImageExt.h"
#import "UIImage+fixOrientation.h"
#import "UUID.h"
#import "SNViewController.h"
#import "VideoUploadModel.h"

//#define IMAGE_BASE_URL @"http://thunisoa.931.com/upload/"// 图片的链接固定部分
//
//#define BASE_URL               @"http://thunisoa.931.com/webservices/" // 主机地址
//#define IMAGE_BASE_URL @"http://unisoa.931.com/upload/"// 图片的链接固定部分
//
//#define BASE_URL               @"http://unisoa.931.com/webservices/" // 主机地址
// 骨科地址
#define IMAGE_BASE_URL @"http://guke.931.com/upload/"// 图片的链接固定部分

#define BASE_URL               @"http://guke.931.com/webservices/" // 主机地址


#define USER_LOGING_URL        @"login.php"                     // 1、用户登入接口
#define FRIEND_LIST_URL        @"friendlist.php"                // 36、好友列表
#define USER_INFO_BYID_URL     @"userinfobyid.php"              // 18、根据用户id查看用户信息
#define FRIEND_ADD_URL         @"friendadd.php"                 // 39、添加好友
#define FEEDBACK_URL           @"feedback.php"                  // 53、提交意见反馈
#define DEL_GROUP_URL          @"delgroup.php"                  // 13、删除群组
#define CONTACT_LIST_URL       @"contactlist.php"               // 5、站内信联系人列表
#define NEW_ARTICLE_LIST       @"newarticlelist.php"            // 14、公开信及群组最新信息列表
#define CHANGE_ARTICLE_BG      @"changearticlebg.php"           // 52、修改朋友圈背景图
#define USER_ARTICLE_LIST      @"userarticlelist.php"           // 42、朋友圈文章列表
#define USERE_ARTICEL_COMMENT_NEW @"userarticlecommentnew.php"  // 44、发表朋友圈评论
#define USER_ARTICLE_COMMENT_DEL  @"userarticlecommentdel.php"  // 46、删除朋友圈评论
#define USER_ARTICEL_NEW       @"userarticlenew.php"            // 3、发表朋友圈文章
#define NEW_ARTICLE_LIST       @"newarticlelist.php"            // 14、公开信及群组最新信息列表
#define USER_CONTACT_SAVE      @"usercontactsave.php"           // 20、保存用户联系人

#define FORGET_PWD_URL         @"forgetpwd.php"                 // 忘记密码
#define USER_CHANGIFO_URL      @"changeinfo.php"                // 修改信息列表
#define USER_CHANGPWD_URL      @"changepwd.php"                 // 修改密码
#define NEW_INVITECODE_URL     @"newinvitecode.php"             // 取得新邀请码
#define CHANG_ICON_URL         @"changeicon.php"                // 修改头像
#define CHECK_UPDATE_URL       @"checkupdate.php"               // 检查是否有更新
#define UPLOAD_CER_URL         @"uploadcert.php"                // 上传认证资料
#define CODE_CER_UER           @"codecert.php"                  // 通过邀请码认证
#define USER_LIST_URL          @"userlist.php"                  // 审核通过用户列表
#define CREATE_GROUP           @"creategroup.php"               // 创建群组
#define USER_CONTACT           @"usercontact.php"               // 用户群组及联系人列表
#define USER_ADDED_GROUP_LIST  @"useraddedgrouplist.php"        // 用户加入及创建的群组列表
#define USER_CONTACT_SAVE      @"usercontactsave.php"           // 保存用户联系人
#define CRASH_REPORT           @"crashreport.php"               // 提交错误日志
#define GROUP_INFO_URL         @"groupinfo.php"                 // 查看群组信息
#define CHANG_GROUP_NAME       @"changegroupname.php"           // 51、修改群组名称
#define CHANGE_GROUP_MEMO      @"changegroupmemo.php"           // 修改群组备注信息
#define GROUP_MEMBER_LIST      @"groupmemberlist.php"           // 群组用户列表
#define USER_SEARCH_URL        @"usersearch.php"                // 搜索用户
#define ADD_GROUP_MEMBER       @"addgroupmember.php"            // 增加用户至群组
#define DEL_GROUP_MEMBER       @"delgroupmember.php"            // 删除群组用户
#define ARTICLE_TYPE_LIST      @"articletypelist.php"           // 取得公开信分类
#define ARTICLE_LIST_URL       @"articlelist.php"               // 公开信及群组信息列表
#define ARTICLE_URL            @"article.php"                   // 公开信正文及附件列表
#define ARTICLE_COMMENT_LIST   @"articlecommentlist.php"        // 公开信评论列表
#define NEW_ARTICLE_URL        @"newarticle.php"                // 发表公开信及群组信息
#define MATTER_LIST            @"tasklist.php"                  // 任务列表
#define FRIEND_NEW_URL         @"friendnewlist.php"             // 未审核好友列表
#define SUB_USER_COUNT_URL     @"subusercount.php"              // 取得下级用户数量
#define SUB_USER_LIST_URL     @"subuserlist.php"               // 取得下级用户列表
#define UPLOAD_TOCKEN_URL     @"uploadtoken.php"              //  75、上传用户deviceToken


#pragma mark - soulnear
#pragma mark - 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#pragma mark - 屏幕宽度
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#pragma mark - 屏幕高度
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - 业界动态接口
#define INDUSTRY_NEWS_URL @"dongtailist.php"
#pragma mark - 动态正文
#define INDUSTRY_NEWS_DETAIL_URL @"dongtai.php"
#pragma mark - 主题分类接口
#define TOPIC_DISCUSS_TYPE_URL @"zhutitypelist.php"
#pragma mark - 主题列表接口
#define TOPIC_DISCUSS_LIST_URL @"zhutilist.php"
#pragma mark - 主题正文接口
#define TOPIC_DISCUSS_DETAIL_URL @"zhuti.php"
#pragma mark - 主题评论接口
#define TOPIC_DISCUSS_COMMENT_URL @"zhutireplylist.php"
#pragma mark - 对主题进行评论接口
#define TOPIC_DISCUSS_COMMIT_URL @"zhutireplynew.php"


#pragma mark -病历列表
#define BINGLI_LIST @"binglilist.php"
#pragma mark - 病例正文
#define BINGLI_DETAIL_URL @"bingli.php"
#pragma mark - 发表或修改病历
#define WRITE_BINGLI_URL @"binglinew.php"
#pragma mark - 删除病历
#define BINGLI_DELETE_URL @"binglidel.php"
#pragma mark - 病例分类列表
#define BINGLI_TYPE_LIST_URL @"binglifenleilist.php"
#pragma mark - 获取病历标签列表
#define BINGLI_TAG_LIST_URL @"binglitaglist.php"
#pragma mark - 删除病例库标签
#define BINGLI_TAG_DELETE_URL @"binglitagdel.php"
#pragma mark - 新增病例库标签
#define BINGLI_TAG_ADD_URL @"binglitagnew.php"
#pragma mark - 病历分享到讨论组
///病历分享到讨论组
#define BINGLI_SHARE_GROUPS_URL @"binglisharegroup.php"

#pragma mark - 资料库分享到讨论组
///资料库分享到讨论组
#define ZILIAOKU_SHARE_GROUPS_URL @"infosharegroup.php"


#pragma mark - 删除朋友圈文章
#define DELETE_BLOG_URL @"userarticledel.php"




#pragma mark - gm
#pragma mark - 日历活动
#define CALENDAR_ACTIVITIES @"eventstatus.php"
#pragma mark - 活动列表
#define CALENDAR_ACTIVITIESTABLEVIEW @"eventlist.php"

// 请求参数
#define REQUEST_PATAMETER  @{@"userId": [NSString stringWithFormat:@"%d",((User_Model*)[[SingleInstance shareManager].objecAarray firstObject]).userId],@"sid": ((User_Model*)[[SingleInstance shareManager].objecAarray firstObject]).sid}
//定义请求服务的返回参数
#define CODE_SUCCESS 0
#define CODE_ERROE 1
#define CODE_OTHER 2
// 6 ---个人  2-----群组
#define ORDINARY_USER_CODE @"6"
#define ORDINARY_GROUP_CODE @"2"
// 群组类型参数 0——系统群 1——普通群
#define GROUPTYPE_SYSTEM_CODE @"1"
#define GROUPTYPE_NORMAL_CODE @"0"
/*评论类型*/
#define COMMENT_TYPE_CODE @"0"
#define GOOD_TYPE_CODE @"1"
#define DEL_GOOD_TYPE_CODE @"2"
/*是否为分享*/
#define IS_SHARE_CODE @"1"
#define ISNOT_SHARE_CODE @"0"
// 诊疗圈分享来源
#define SOURCE_FROME_URL @"0"// 分享的链接
#define SOURCE_FROME_WECHAT @"1"// 分享自微信
#define SOURCE_FROME_CASE @"2" // 分享自病例库
#define SOURCE_FROME_MATERIAL @"3" // 分享自资料库
// 讨论组分享来源
#define SOURCE_GROUP_NONE @"0" // 无分享来源
#define SOURCE_GROUP_CASE @"1" // 分享自资料库
#define SOURCE_GROUP_MATERIAL @"2" //分享自病例库
// 视图的TAG宏定义
#define SEARCH_BTN_TAG 201
#define ADD_BTN_TAG 202
#define SET_BTN_TAG 203
#define CONTACT_BTN_TAG 204
#define MATTER_BTN_TAG 205
#define MOMENTS_BTN_TAG 206
#define COCHAT_BTN_TAG 207
#define DIALOG_Btn_TAG 208
#define SUBMIT_BTN_TAG 209
#define INFORMATION_BTN_TAG 210
#define MEDICAL_BTN_TAG 211

/*
 数据本地缓存标记
 */
//当前用户的标志
#define CATCH_TYPE_ID [model.userId intValue]

#define FREIENDLIST_CATCH_ID  1
#define FRIEND_DETAIL_CATCH_ID 2
#define CONTACT_LIST_CATCH_ID 3
#define FRIENDDTAILE_IN_CATCH_ID 4
#define USERADDGROUPLIST_CATCH_ID 5
#define GETMATTERLIST_CATCH_ID 6
#define PUTMATTERLIST_CATCH_ID 7
#define ALL_GETMATTERLIST_CATCH_ID 8
#define ALL_PUTMATTERLIST_CATCH_ID 9
#define GROUP_LIST_CATCH_ID 10
#define GROUP_MEMEBER_LIST_CATCH_ID 11
#define FRIENDADDNEW_CATCH_IB 12
// 群聊 广场 群组
#define VCHATTYPE_VC 4
#define VCHATTYPE_PGROUP 2
#define VCHATTYPE_PCHAT 6

// 获取当前用户的userId和sId
#define GET_USER_ID [[NSUserDefaults standardUserDefaults] objectForKey:U_ID]
#define GET_S_ID [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_K]
#define GET_U_NAME [[NSUserDefaults standardUserDefaults] objectForKey:U_NAME]
//#define GET_GROUP_ID [[NSUserDefaults standardUserDefaults] objectForKey:U_NAME]
#define IS_AUTOLOG [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"] boolValue]
#define TABLE_HEIGHT [[[NSUserDefaults standardUserDefaults] objectForKey:@"tableHeight"] floatValue]
/*
 检测网络数据是否有变化
 */
#define IS_DATACHANG @"is_data_chang"
#endif
