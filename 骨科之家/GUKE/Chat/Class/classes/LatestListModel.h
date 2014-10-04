//
//  LatestListModel.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-6-7.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VChatModel;
/*
 addTime = "2014-02-03 08:14:52";
 createDate = "";
 creator = 212;
 creatorName = "\U5f90\U6e10";
 denytalk = 0;
 groupId = 2;
 groupName = "\U7814\U53d1\U90e8";
 groupType = 1;
 isCreator = 0;
 latestMsg = "\U770b\U5230\U4e86";
 latestMsgUser = "";
 latestMsgUserName = "\U9648\U6d77\U6d9b";
 membermemo = "";
 memo = "";
 */
@interface LatestListModel : NSObject
@property (nonatomic,strong) NSString *l_addTime;
@property (nonatomic,strong) NSString *l_createDate;
@property (nonatomic,strong) NSString *l_creator;
@property (nonatomic,strong) NSString *l_creatorName;
@property (nonatomic,strong) NSString *l_denytalk;
@property (nonatomic,strong) NSString *l_groupId;
@property (nonatomic,strong) NSString *l_groupName;
@property (nonatomic,strong) NSString *l_groupType;
@property (nonatomic,strong) NSString *l_isCreator;
@property (nonatomic,strong) NSString *l_latestMsg;
@property (nonatomic,strong) NSString *l_latestMsgUser;
@property (nonatomic,strong) NSString *l_latestMsgUserName;
@property (nonatomic,strong) NSString *l_membermemo;
@property (nonatomic,strong) NSString *l_memo;

+ (NSArray *)makeModel:(id)datas withType:(BOOL)isloacal;
@property (nonatomic,assign) BOOL isNewMsg;
@property (nonatomic,strong) VChatModel *latestArticleModel;
@end


typedef enum{
    ContactType_Other = 0,
	ContactType_Group,//群组
	ContactType_P,//私聊
} ContactType;

@interface LatestContactModel : NSObject
@property (nonatomic,assign) ContactType contactType;
@property (nonatomic,strong) NSString *c_contactType;
@property (nonatomic,strong) NSString *c_contactId;
@property (nonatomic,strong) NSString *c_contactName;
@property (nonatomic,strong) NSString *c_contactUsername;
@property (nonatomic,strong) NSString *c_createDate;
@property (nonatomic,strong) NSString *c_creator;
@property (nonatomic,strong) NSString *c_creatorName;
@property (nonatomic,strong) NSString *c_creatorUsername;
@property (nonatomic,strong) NSString *c_lastMsg;
@property (nonatomic,strong) NSString *c_lastMsgUser;
@property (nonatomic,strong) NSString *c_lastMsgTime;
@property (nonatomic,strong) NSString *c_lastMsgUserUsername;
@property (nonatomic,strong) NSString *c_lastMsgUserFirstname;
@property (nonatomic,strong) NSString *c_memo;
@property (nonatomic,assign) BOOL isNewMsg;
+ (NSArray *)makeModel:(id)datas withType:(BOOL)isloacal;
@property (nonatomic,strong) VChatModel *latestArticleModel;
@end







