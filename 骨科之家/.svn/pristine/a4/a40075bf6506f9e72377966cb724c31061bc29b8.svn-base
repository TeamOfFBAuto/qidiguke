//
//  VChatModel.h
//  VColleagueChat
//
//  Created by lqy on 4/29/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#warning ....需要mrc支持

#define TYPEID_GROUP 9


#import <Foundation/Foundation.h>
#import "VChatViewController.h"
#import "StatusModel.h"
@interface VChatModel : NSObject


@property (nonatomic,assign) NSInteger articleId;
@property (nonatomic,retain) NSString *title;

//发表人信息
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *firstname;
@property (nonatomic,retain) NSString *firstUsername;

@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) NSString *iconUpdateTime;
@property (nonatomic,retain) UIImage *imgData;


@property (nonatomic,retain) NSString *creatDate;

@property (nonatomic,retain) NSString *uid;//客服端对应的唯一标识  自己定义的



//发送文本类型
@property (nonatomic,retain) NSString *context;
@property (nonatomic,retain) id attachlist;//arr --- 类型根据attachlist来构建sendType;

//虚拟的数据 对应着attachlist 第一个数据 可能不存在
@property (nonatomic,retain) NSString *virtualVoiceurl;
@property (nonatomic,retain) NSString *virtualVoicelength;
@property (nonatomic,retain) NSString *virtualPicurl;


//暂时不知道干嘛用的
@property (nonatomic,retain) NSString *voiceurl;
@property (nonatomic,retain) NSString *voiceLength;
@property (nonatomic,retain) NSString *picurl;

//发送对象类型
@property (nonatomic,retain) NSString *typeId;//消息分类 ，群聊，私聊之类的
@property (nonatomic,retain) NSString *isGroupArticle;
@property (nonatomic,retain) NSString *recvId;


@property (nonatomic,assign) SEND_TYPE sendType;//文件的类型

//model satus
@property (nonatomic,retain) StatusModel *statusModel;
// 是否发送成功的标注
@property (nonatomic,retain) NSString *isSend;


+ (NSArray *)vChatMakeModel:(NSArray *)datas;

@end

// 图片和声音的附件
@interface VChatAttachModel : NSObject
@property (nonatomic,retain) NSString *attachId;
@property (nonatomic,retain) NSString *filename;
@property (nonatomic,retain) NSString *displayHtml;
@property (nonatomic,retain) NSString *fileurl;
@property (nonatomic,retain) NSString *voiceLength;
@property (nonatomic,retain) NSString *Length;
@property (nonatomic,retain) NSData *fielData;//暂存文件转为data数据
@property (nonatomic,assign) NSInteger isRead;// 标注声音文件是否已读


@end




