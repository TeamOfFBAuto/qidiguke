//
//  addNewContact.m
//  UNITOA
//
//  Created by qidi on 14-8-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "addNewContact.h"
#import "Interface.h"
#import "userContactDB.h"
#import "UserContact.h"
#import "UserInfoDB.h"
@implementation addNewContact
// 将新的聊天好友添加到本地数据库中
+ (void)addUserContact:(NSString *)contactId{
    //NSString *contactId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"dataId"]];
    if (contactId == nil || [contactId isEqualToString:@"(null)"] || [contactId isEqual:[NSNull null]]) {
        return;
    }
    else{
        // 保存到本地
        UserContact *model = [[UserContact alloc]init];
        model.contactId = contactId;
        model.contactName = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_USER_ID anduserId:contactId];
        model.contactType = @"6";
        model.contactUsername = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:contactId];
        model.creatDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        model.creator = @"0";
        model.creatorName = @"";
        model.creatorUsername = @"";
        model.groupType = @"0";
        model.lastMsg = @"";
        model.lastMsgTime = @"";
        model.lastMsgTime = @"";
        model.lastMsgUserFirstname = @"";
        model.lastMsgUserUsername = @"";
        model.isTop = @"0";
        model.topOperateTime = @"0";
        model.isMute = @"0";
        model.lastMsgNum = @"0";
        [userContactDB selectuserContactInfo:USERCONTACT_TABLE andkeyValue:model andkeyArray:[addNewContact getFieldArray]];
        // 保存到服务器上
        NSDictionary *paramter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"contactId":contactId};
        [AFRequestService responseData:USER_CONTACT_SAVE andparameters:paramter andResponseData:^(NSData *responseData) {
            
        }];
    }
}

// 设置数据库字段数组
+ (NSArray *)getFieldArray{
    return @[
             @"cuId",
             @"contactId",
             @"contactName",
             @"contactType",
             @"contactUsername",
             @"createDate",
             @"creator",
             @"creatorName",
             @"creatorUsername",
             @"groupType",
             @"lastMsg",
             @"lastMsgTime",
             @"lastMsgUser",
             @"lastMsgUserFirstname",
             @"lastMsgUserUsername",
             @"isTop",
             @"topOperateTime",
             @"isMute",
             @"lastMsgNum"
             ];
}
@end
