//
//  LatestListModel.m
//  VColleagueChat
//
//  Created by Ming Zhang on 14-6-7.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LatestListModel.h"
#import "SqliteBase.h"
#import "VChatModel.h"
@implementation LatestListModel

- (void)dealloc{
    
    SSRCSafeRelease(_l_addTime)
    SSRCSafeRelease(_l_createDate)
    SSRCSafeRelease(_l_creator)
    SSRCSafeRelease(_l_creatorName)
    SSRCSafeRelease(_l_denytalk)
    SSRCSafeRelease(_l_groupId)
    SSRCSafeRelease(_l_groupName)
    SSRCSafeRelease(_l_groupType)
    SSRCSafeRelease(_l_isCreator)
    SSRCSafeRelease(_l_latestMsg)
    SSRCSafeRelease(_l_latestMsgUser)
    SSRCSafeRelease(_l_latestMsgUserName)
    SSRCSafeRelease(_l_membermemo)
    SSRCSafeRelease(_l_memo)
    SSRCSuperDealloc
}
+ (NSArray *)makeModel:(id)datas withType:(BOOL)isloacal{
    NSMutableArray *da = [NSMutableArray array];
    NSLog(@"-ss------%d",[datas count]);
    if (datas && [datas isKindOfClass:[NSArray class]]) {
        for (id dic in datas) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                LatestListModel *model = [[LatestListModel alloc] init];
                id groupId = [dic objectForKey:@"groupId"];
                id groupName = [dic objectForKey:@"groupName"];
//                id creator = [dic objectForKey:@"creator"];
//                id creatorName = [dic objectForKey:@"creatorName"];
//                id createDate = [dic objectForKey:@"createDate"];
//                id latestMsg = [dic objectForKey:@"latestMsg"];
//                id addTime = [dic objectForKey:@"addTime"];
//                id isCreator = [dic objectForKey:@"isCreator"];
//                id memo = [dic objectForKey:@"memo"];
                if (groupId) {
                    model.l_groupId = [NSString stringWithFormat:@"%@",groupId];
                }else{
                    return da;
                }
                if (groupName) {
                    model.l_groupName = [NSString stringWithFormat:@"%@",groupName];
                }
                id latestArticle = [dic objectForKey:@"latestArticle"];
                if ([latestArticle isKindOfClass:[NSDictionary class]]) {
                    NSArray *ad = [VChatModel vChatMakeModel:[NSArray arrayWithObject:latestArticle]];
                    if (ad.count) {
                        model.latestArticleModel = [ad objectAtIndex:0];
                    }
                }
                if (!isloacal && model.latestArticleModel) {
                    //判断
                    if ([SqliteBase isInDataBase:[NSString stringWithFormat:@"%d",model.latestArticleModel.articleId]] ) {
                        model.isNewMsg = YES;
                    }
                }
                [da addObject:model];
            }
        }
    }
    return da;
}
@end
@implementation LatestContactModel
- (void)dealloc{
    
    SSRCSafeRelease(_c_contactType)
    SSRCSafeRelease(_c_contactId)
    SSRCSafeRelease(_c_contactName)
    SSRCSafeRelease(_c_contactUsername)
    SSRCSafeRelease(_c_createDate)
    SSRCSafeRelease(_c_creator)
    SSRCSafeRelease(_c_creatorName)
    SSRCSafeRelease(_c_creatorUsername)
    SSRCSafeRelease(_c_lastMsg)
    SSRCSafeRelease(_c_lastMsgUser)
    SSRCSafeRelease(_c_lastMsgUserUsername)
    SSRCSafeRelease(_c_lastMsgTime)
    SSRCSafeRelease(_c_lastMsgUserFirstname)
    SSRCSafeRelease(_c_memo)
    SSRCSuperDealloc
}
+ (NSArray *)makeModel:(id)datas withType:(BOOL)isloacal{
    NSMutableArray *da = [NSMutableArray array];
    if (datas && [datas isKindOfClass:[NSArray class]]) {
        for (id dic in datas) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                LatestContactModel *model = [[LatestContactModel alloc] init];
                id contactType = [dic objectForKey:@"contactType"];
                id contactId = [dic objectForKey:@"contactId"];
                id contactName = [dic objectForKey:@"contactName"];
                id contactUsername = [dic objectForKey:@"contactUsername"];
                NSLog(@"数据猿:%@",dic);
                if (contactId) {
                    model.c_contactId = [NSString stringWithFormat:@"%@",contactId];
                }else{
                    return da;
                }
                if (contactName) {
                    model.c_contactName = [NSString stringWithFormat:@"%@",contactName];
                }
                if (contactType) {
                    model.c_contactType = [NSString stringWithFormat:@"%@",contactType];
                }
                if (contactUsername) {
                    model.c_contactUsername = [NSString stringWithFormat:@"%@",contactUsername];
                }
                if ([model.c_contactType isEqualToString:@"6"]) {
                    model.contactType = ContactType_P;
                }else if([model.c_contactType isEqualToString:@"2"]){
                    model.contactType = ContactType_Group;
                }else{
                    model.contactType = ContactType_Other;
                }
                
                id latestArticle = [dic objectForKey:@"latestArticle"];
                if ([latestArticle isKindOfClass:[NSDictionary class]]) {
                    NSArray *ad = [VChatModel vChatMakeModel:[NSArray arrayWithObject:latestArticle]];
                    if (ad.count) {
                        model.latestArticleModel = [ad objectAtIndex:0];
                    }
                }
                if (!isloacal && model.latestArticleModel) {
                    //判断
                    if ([SqliteBase isInDataBase:[NSString stringWithFormat:@"%d",model.latestArticleModel.articleId]] ) {
                        model.isNewMsg = YES;
                    }
                }
                [da addObject:model];
            }
        }
    }
    return da;
}

@end