//
//  SqliteFieldAndTable.m
//  UNITOA
//
//  Created by qidi on 14-7-23.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SqliteFieldAndTable.h"
#import "UserInfoDB.h"
#import "UserAddedGroupDB.h"
#import "GroupList.h"
#import "GroupMemberList.h"
#import "GroupMember.h"
#import "userContactDB.h"
#import "UserContact.h"
#import "Interface.h"
@implementation SqliteFieldAndTable
- (void)getAllInfo
{
    // 网络请求用户信息
    //if ([UserInfoDB selectCount:nil andcuId:GET_USER_ID] > 0) {
        NSDictionary  *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
        [AFRequestService responseData:USER_LIST_URL andparameters:parameters andResponseData:^(NSData *responseData) {
            NSDictionary * dict = (NSDictionary *)responseData;
            [self getFeildandValue:dict];
        }];
    // 网络请求群组数据
    NSDictionary *params = @{@"userId":GET_USER_ID,@"sid":GET_S_ID, @"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_ADDED_GROUP_LIST andparameters:params andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        [self getGroupFeildandValue:dict];
    } ];
    
    // 网络请求用户群组及联系人列表数据
    NSDictionary *contactParams = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_CONTACT andparameters:contactParams andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        [self getUserContactFeildandValue:dict];
        
    }];
}
- (void)getUserInfo
{
    // 网络请求用户信息
    if ([UserInfoDB selectCount:nil andcuId:GET_USER_ID] > 0) {
    NSDictionary  *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
    [AFRequestService responseData:USER_LIST_URL andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        [self getFeildandValue:dict];
    }];
    }
    else{
        return;
    }
}
- (void)getGroupInfo
{
    // 网络请求群组数据
   
    NSDictionary *params = @{@"userId":GET_USER_ID,@"sid":GET_S_ID, @"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_ADDED_GROUP_LIST andparameters:params andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        [self getGroupFeildandValue:dict];
    } ];
}
- (void)getGroupMemberInfo
{
    // 网络请求用户群组及联系人列表数据
    NSDictionary *contactParams = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_CONTACT andparameters:contactParams andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        [self getUserContactFeildandValue:dict];
        
    }];
}

//将站内用户信息的字段和值(userInfo)
- (BOOL)getFeildandValue:(NSDictionary *)userIfo
{
    
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        NSDictionary *userLists = [userIfo objectForKey:@"userlist"];
        for (NSDictionary *userInfo in userLists) {
            UserIfo *model = [[UserIfo alloc]init];
            model.address = [NSString _859ToUTF8:[userInfo valueForKey:@"address"]];
            model.allowPosition = [NSString _859ToUTF8:[userInfo valueForKey:@"allowPosition"]];
            model.articleBg = [NSString _859ToUTF8:[userInfo valueForKey:@"articleBg"]];
            model.bgUpdateTime = [NSString _859ToUTF8:[userInfo valueForKey:@"bgUpdateTime"]];
            model.chkATime = [NSString _859ToUTF8:[userInfo valueForKey:@"chkATime"]];
            model.cityName = [NSString _859ToUTF8:[userInfo valueForKey:@"cityName"]];
            model.companyId = [NSString _859ToUTF8:[userInfo valueForKey:@"companyId"]];
            model.createDate = [NSString _859ToUTF8:[userInfo valueForKey:@"createDate"]];
            model.deletePerm = [NSString _859ToUTF8:[userInfo valueForKey:@"deletePerm"]];
            model.district = [NSString _859ToUTF8:[userInfo valueForKey:@"district"]];
            model.email = [NSString _859ToUTF8:[userInfo valueForKey:@"email"]];
            model.firstname = [NSString _859ToUTF8:[userInfo valueForKey:@"firstname"]];
            model.firstnameen = [NSString _859ToUTF8:[userInfo valueForKey:@"firstnameen"]];
            model.icon = [NSString _859ToUTF8:[userInfo valueForKey:@"icon"]];
            model.iconUpdateTime = [NSString _859ToUTF8:[userInfo valueForKey:@"iconUpdateTime"]];
            model.inviteCodeId = [NSString _859ToUTF8:[userInfo valueForKey:@"inviteCodeId"]];
            model.invitePerm = [NSString _859ToUTF8:[userInfo valueForKey:@"invitePerm"]];
            model.itcode = [NSString _859ToUTF8:[userInfo valueForKey:@"itcode"]];
            model.lastChkETime = [NSString _859ToUTF8:[userInfo valueForKey:@"lastChkETime"]];
            model.lastLogin = [NSString _859ToUTF8:[userInfo valueForKey:@"lastLogin"]];
            model.lastLoginIP = [NSString _859ToUTF8:[userInfo valueForKey:@"lastLoginIP"]];
            model.latitude = [NSString _859ToUTF8:[userInfo valueForKey:@"latitude"]];
            model.loginCount = [NSString _859ToUTF8:[userInfo valueForKey:@"loginCount"]];
            model.longitude = [NSString _859ToUTF8:[userInfo valueForKey:@"longitude"]];
            model.mailStatus = [NSString _859ToUTF8:[userInfo valueForKey:@"mailStatus"]];
            model.memo = [NSString _859ToUTF8:[userInfo valueForKey:@"memo"]];
            model.mobile = [NSString _859ToUTF8:[userInfo valueForKey:@"mobile"]];
            model.organization = [NSString _859ToUTF8:[userInfo valueForKey:@"organization"]];
            model.organizationen = [NSString _859ToUTF8:[userInfo valueForKey:@"organizationen"]];
            model.parentCode = [NSString _859ToUTF8:[userInfo valueForKey:@"parentCode"]];
            model.parentId = [NSString _859ToUTF8:[userInfo valueForKey:@"parentId"]];
            model.position = [NSString _859ToUTF8:[userInfo valueForKey:@"position"]];
            model.positionen = [NSString _859ToUTF8:[userInfo valueForKey:@"positionen"]];
            model.province = [NSString _859ToUTF8:[userInfo valueForKey:@"province"]];
            model.sex = [NSString _859ToUTF8:[userInfo valueForKey:@"sex"]];
            model.showMobile = [NSString _859ToUTF8:[userInfo valueForKey:@"showMobile"]];
            model.sid = [NSString _859ToUTF8:[userInfo valueForKey:@"sid"]];
            model.status = [NSString _859ToUTF8:[userInfo valueForKey:@"status"]];
            model.street = [NSString _859ToUTF8:[userInfo valueForKey:@"street"]];
            model.street_number = [NSString _859ToUTF8:[userInfo valueForKey:@"street_number"]];
            model.sysAdmin = [NSString _859ToUTF8:[userInfo valueForKey:@"sysAdmin"]];
            model.telephone = [NSString _859ToUTF8:[userInfo valueForKey:@"telephone"]];
            model.userId = [NSString _859ToUTF8:[userInfo valueForKey:@"userId"]];
            model.userType = [NSString _859ToUTF8:[userInfo valueForKey:@"userType"]];
            model.username = [NSString _859ToUTF8:[userInfo valueForKey:@"username"]];
            model.versionName = [NSString _859ToUTF8:[userInfo valueForKey:@"versionName"]];
            model.isFriend = [NSString _859ToUTF8:[userInfo valueForKey:@"isFriend"]];
            
            
            NSArray *valueArray = @[
                                    @"cuId",
                                    @"userId",
                                    @"username",
                                    @"address",
                                    @"allowPosition",
                                    @"articleBg",
                                    @"bgUpdateTime",
                                    @"chkATime",
                                    @"cityName",
                                    @"company",
                                    @"companyId",
                                    @"district",
                                    @"email",
                                    @"firstname",
                                    @"firstnameen",
                                    @"icon",
                                    @"iconUpdateTime",
                                    @"inviteCodeId",
                                    @"itcode",
                                    @"lastChkETime",
                                    @"latitude",
                                    @"longitude",
                                    @"memo",
                                    @"mobile",
                                    @"organization",
                                    @"organizationen",
                                    @"parentCode",
                                    @"parentId",
                                    @"position",
                                    @"positionen",
                                    @"province",
                                    @"sex",
                                    @"showMobile",
                                    @"street",
                                    @"street_number",
                                    @"sysAdmin",
                                    @"telephone",
                                    @"versionName",
                                    @"isFriend"];
            [UserInfoDB selectUserInfo:USERIFO_TABLE andkeyValue:model andkeyArray:valueArray];
             model = nil;
        }
        
        return YES;
    }
    else if (codeNum == CODE_ERROE){
        [self repeatLogin:^(BOOL flag) {
            if (flag) {
                [self getUserInfo];
            }
            else{
                return;
            }
            
        }];
        return NO;
    }
    else{
        
        return NO;
    }
    
}
//将站内用户信息的字段和值(userInfo)
- (void)getFeildandValueById:(NSDictionary *)userIfo
{

        NSDictionary *userList = [userIfo objectForKey:@"user"];
            UserIfo *model = [[UserIfo alloc]init];
            model.address = [NSString _859ToUTF8:[userList valueForKey:@"address"]];
            model.allowPosition = [NSString _859ToUTF8:[userList valueForKey:@"allowPosition"]];
            model.articleBg = [NSString _859ToUTF8:[userList valueForKey:@"articleBg"]];
            model.bgUpdateTime = [NSString _859ToUTF8:[userList valueForKey:@"bgUpdateTime"]];
            model.chkATime = [NSString _859ToUTF8:[userList valueForKey:@"chkATime"]];
            model.cityName = [NSString _859ToUTF8:[userList valueForKey:@"cityName"]];
            model.companyId = [NSString _859ToUTF8:[userList valueForKey:@"companyId"]];
            model.createDate = [NSString _859ToUTF8:[userList valueForKey:@"createDate"]];
            model.deletePerm = [NSString _859ToUTF8:[userList valueForKey:@"deletePerm"]];
            model.district = [NSString _859ToUTF8:[userList valueForKey:@"district"]];
            model.email = [NSString _859ToUTF8:[userList valueForKey:@"email"]];
            model.firstname = [NSString _859ToUTF8:[userList valueForKey:@"firstname"]];
            model.firstnameen = [NSString _859ToUTF8:[userList valueForKey:@"firstnameen"]];
            model.icon = [NSString _859ToUTF8:[userList valueForKey:@"icon"]];
            model.iconUpdateTime = [NSString _859ToUTF8:[userList valueForKey:@"iconUpdateTime"]];
            model.inviteCodeId = [NSString _859ToUTF8:[userList valueForKey:@"inviteCodeId"]];
            model.invitePerm = [NSString _859ToUTF8:[userList valueForKey:@"invitePerm"]];
            model.itcode = [NSString _859ToUTF8:[userList valueForKey:@"itcode"]];
            model.lastChkETime = [NSString _859ToUTF8:[userList valueForKey:@"lastChkETime"]];
            model.lastLogin = [NSString _859ToUTF8:[userList valueForKey:@"lastLogin"]];
            model.lastLoginIP = [NSString _859ToUTF8:[userList valueForKey:@"lastLoginIP"]];
            model.latitude = [NSString _859ToUTF8:[userList valueForKey:@"latitude"]];
            model.loginCount = [NSString _859ToUTF8:[userList valueForKey:@"loginCount"]];
            model.longitude = [NSString _859ToUTF8:[userList valueForKey:@"longitude"]];
            model.mailStatus = [NSString _859ToUTF8:[userList valueForKey:@"mailStatus"]];
            model.memo = [NSString _859ToUTF8:[userList valueForKey:@"memo"]];
            model.mobile = [NSString _859ToUTF8:[userList valueForKey:@"mobile"]];
            model.organization = [NSString _859ToUTF8:[userList valueForKey:@"organization"]];
            model.organizationen = [NSString _859ToUTF8:[userList valueForKey:@"organizationen"]];
            model.parentCode = [NSString _859ToUTF8:[userList valueForKey:@"parentCode"]];
            model.parentId = [NSString _859ToUTF8:[userList valueForKey:@"parentId"]];
            model.position = [NSString _859ToUTF8:[userList valueForKey:@"position"]];
            model.positionen = [NSString _859ToUTF8:[userList valueForKey:@"positionen"]];
            model.province = [NSString _859ToUTF8:[userList valueForKey:@"province"]];
            model.sex = [NSString _859ToUTF8:[userList valueForKey:@"sex"]];
            model.showMobile = [NSString _859ToUTF8:[userList valueForKey:@"showMobile"]];
            model.sid = [NSString _859ToUTF8:[userList valueForKey:@"sid"]];
            model.status = [NSString _859ToUTF8:[userList valueForKey:@"status"]];
            model.street = [NSString _859ToUTF8:[userList valueForKey:@"street"]];
            model.street_number = [NSString _859ToUTF8:[userList valueForKey:@"street_number"]];
            model.sysAdmin = [NSString _859ToUTF8:[userList valueForKey:@"sysAdmin"]];
            model.telephone = [NSString _859ToUTF8:[userList valueForKey:@"telephone"]];
            model.userId = [NSString _859ToUTF8:[userList valueForKey:@"userId"]];
            model.userType = [NSString _859ToUTF8:[userList valueForKey:@"userType"]];
            model.username = [NSString _859ToUTF8:[userList valueForKey:@"username"]];
            model.versionName = [NSString _859ToUTF8:[userList valueForKey:@"versionName"]];
            model.isFriend = [NSString _859ToUTF8:[userList valueForKey:@"isFriend"]];
            
            
            NSArray *valueArray = @[
                                    @"cuId",
                                    @"userId",
                                    @"username",
                                    @"address",
                                    @"allowPosition",
                                    @"articleBg",
                                    @"bgUpdateTime",
                                    @"chkATime",
                                    @"cityName",
                                    @"company",
                                    @"companyId",
                                    @"district",
                                    @"email",
                                    @"firstname",
                                    @"firstnameen",
                                    @"icon",
                                    @"iconUpdateTime",
                                    @"inviteCodeId",
                                    @"itcode",
                                    @"lastChkETime",
                                    @"latitude",
                                    @"longitude",
                                    @"memo",
                                    @"mobile",
                                    @"organization",
                                    @"organizationen",
                                    @"parentCode",
                                    @"parentId",
                                    @"position",
                                    @"positionen",
                                    @"province",
                                    @"sex",
                                    @"showMobile",
                                    @"street",
                                    @"street_number",
                                    @"sysAdmin",
                                    @"telephone",
                                    @"versionName",
                                    @"isFriend"];
            [UserInfoDB selectUserInfo:USERIFO_TABLE andkeyValue:model andkeyArray:valueArray];
        model = nil;
  }
// 群组的字段和值
- (BOOL)getGroupFeildandValue:(NSDictionary *)userIfo
{
    BOOL flag = NO;
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        NSArray *groupLists = [userIfo objectForKey:@"grouplist"];
        for (int i = 0; i <[groupLists count]; ++i) {
            NSDictionary *contactlist = (NSDictionary *)groupLists[i];
            GroupList *model = [[GroupList alloc]init];
            model.addTime = [NSString _859ToUTF8:[contactlist objectForKey:@"addTime"]];
            model.createDate = [NSString _859ToUTF8:[contactlist valueForKey:@"createDate"]];
            model.creator = [NSString _859ToUTF8:[contactlist objectForKey:@"creator"]];
            model.creatorName = [NSString _859ToUTF8:[contactlist objectForKey:@"creatorName"]];
            model.denytalk = [NSString _859ToUTF8:[contactlist objectForKey:@"denytalk"]];
            model.groupId = [NSString _859ToUTF8:[contactlist objectForKey:@"groupId"]];
            model.groupName = [NSString _859ToUTF8:[contactlist objectForKey:@"groupName"]];
            model.groupType = [NSString _859ToUTF8:[contactlist objectForKey:@"groupType"]];
            model.isCreator = [NSString _859ToUTF8:[contactlist objectForKey:@"isCreator"]];
            model.latestMsg = [NSString _859ToUTF8:[contactlist objectForKey:@"latestMsg"]];
            model.latestMsgUser = [NSString _859ToUTF8:[contactlist objectForKey:@"latestMsgUser"]];
            model.latestMsgUserName = [NSString _859ToUTF8:[contactlist objectForKey:@"latestMsgUserName"]];
            model.membermemo = [NSString _859ToUTF8:[contactlist objectForKey:@"membermemo"]];
            model.memo = [NSString _859ToUTF8:[contactlist objectForKey:@"memo"]];
            
            NSArray *valueArray = @[
                                    @"cuId",
                                    @"groupId",
                                    @"groupName",
                                    @"groupType",
                                    @"creator",
                                    @"creatorName",
                                    @"isCreator",
                                    @"addTime",
                                    @"createDate",
                                    @"denytalk",
                                    @"latestMsg",
                                    @"latestMsgUser",
                                    @"latestMsgUserName",
                                    @"membermemo",
                                    @"memo"
                                    ];
            if ([UserAddedGroupDB selectGroupInfo:USERADDEDGROUP_TABLE andkeyValue:model andkeyArray:valueArray]) {
                flag = YES;
            }
            model = nil;
            
        }
        
        return flag;
    }
    else if (codeNum == CODE_ERROE){
        [self repeatLogin:^(BOOL flag) {
            if (flag) {
                [self getGroupInfo];
            }
            else{
                return;
            }
            
        }];
        return NO;
    }
    else{
        return NO;
    }
    return flag;
}

- (void)getReturnAddGroup:(NSDictionary *)userIfo
{
            GroupList *model = [[GroupList alloc]init];
            model.addTime = [NSString _859ToUTF8:[userIfo objectForKey:@"createDate"]];// 加入时间标注为群组的创建时间
            model.createDate = [NSString _859ToUTF8:[userIfo valueForKey:@"createDate"]];
            model.creator = [NSString _859ToUTF8:[userIfo objectForKey:@"creator"]];
            model.creatorName = GET_U_NAME;// 创建者的用户名位当前用户名
            model.denytalk = [NSString _859ToUTF8:[userIfo objectForKey:@"denytalk"]];
            model.groupId = [NSString _859ToUTF8:[userIfo objectForKey:@"groupId"]];
            model.groupName = [NSString _859ToUTF8:[userIfo objectForKey:@"groupName"]];
            model.groupType = [NSString _859ToUTF8:[userIfo objectForKey:@"groupType"]];
            model.isCreator = @"1";
            model.latestMsg = [NSString _859ToUTF8:[userIfo objectForKey:@"latestMsg"]];
            model.latestMsgUser = [NSString _859ToUTF8:[userIfo objectForKey:@"latestMsgUser"]];
            model.latestMsgUserName = [NSString _859ToUTF8:[userIfo objectForKey:@"latestMsgUserName"]];
            model.membermemo = [NSString _859ToUTF8:[userIfo objectForKey:@"membermemo"]];
            model.memo = [NSString _859ToUTF8:[userIfo objectForKey:@"memo"]];
            NSArray *valueArray = @[
                                    @"cuId",
                                    @"groupId",
                                    @"groupName",
                                    @"groupType",
                                    @"creator",
                                    @"creatorName",
                                    @"isCreator",
                                    @"addTime",
                                    @"createDate",
                                    @"denytalk",
                                    @"latestMsg",
                                    @"latestMsgUser",
                                    @"latestMsgUserName",
                                    @"membermemo",
                                    @"memo"
                                    ];
            [UserAddedGroupDB selectGroupInfo:USERADDEDGROUP_TABLE andkeyValue:model andkeyArray:valueArray];
    model = nil;
    
}
// 群组成员的字段和值
- (BOOL)getGroupMememberFeildandValue:(NSDictionary *)groupMemberIfo
{
    GroupMemberList *model = [[GroupMemberList alloc]init];
    model.addTime = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"addTime"]];
    model.denytalk = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"denytalk"]];
    model.isCreator = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"isCreator"]];
    model.firstname = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"firstname"]];
    model.membermemo = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"membermemo"]];
    model.userId = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"userId"]];
    model.username = [NSString _859ToUTF8:[groupMemberIfo objectForKey:@"username"]];
    NSArray *valueArray = @[
                            @"cuId",
                            @"groupId",
                            @"userId",
                            @"username",
                            @"firstname",
                            @"isCreator",
                            @"addTime",
                            ];
    
    return [GroupMember selectGroupMemberInfo:GROUPMEMBER_TABLE andkeyValue:model andkeyArray:valueArray];
}
// 用户群组及联系人列表返回字段和值
- (void)getUserContactFeildandValue:(NSDictionary *)userContactIfo
{
    NSUInteger codeNum = [[userContactIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        NSArray *contactlists = [userContactIfo objectForKey:@"contactlist"];
        NSLog(@"%d",[contactlists count]);
        for (int i = [contactlists count]-1; i >=0; --i) {
            NSDictionary *contactlist = (NSDictionary *)contactlists[i];
            UserContact *model = [[UserContact alloc]init];
            model.contactId = [NSString _859ToUTF8:[contactlist objectForKey:@"contactId"]];
            model.contactName = [NSString _859ToUTF8:[contactlist valueForKey:@"contactName"]];
            model.contactType = [NSString _859ToUTF8:[contactlist objectForKey:@"contactType"]];
            model.contactUsername = [NSString _859ToUTF8:[contactlist objectForKey:@"contactUsername"]];
            model.createDate = [NSString _859ToUTF8:[contactlist objectForKey:@"createDate"]];
            model.creator = [NSString _859ToUTF8:[contactlist objectForKey:@"creator"]];
            model.creatorName = [NSString _859ToUTF8:[contactlist objectForKey:@"creatorName"]];
            model.creatorUsername = [NSString _859ToUTF8:[contactlist objectForKey:@"creatorUsername"]];
            model.groupType = [NSString _859ToUTF8:[contactlist objectForKey:@"groupType"]];
            model.lastMsg = [NSString _859ToUTF8:[contactlist objectForKey:@"lastMsg"]];
            model.lastMsgTime = [NSString _859ToUTF8:[contactlist objectForKey:@"lastMsgTime"]];
            model.lastMsgUser = [NSString _859ToUTF8:[contactlist objectForKey:@"lastMsgUser"]];
            model.lastMsgUserFirstname = [NSString _859ToUTF8:[contactlist objectForKey:@"lastMsgUserFirstname"]];
            model.lastMsgUserUsername = [NSString _859ToUTF8:[contactlist objectForKey:@"lastMsgUserUsername"]];
            model.memo = [NSString _859ToUTF8:[contactlist objectForKey:@"memo"]];
            NSArray *valueArray = @[
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
              [userContactDB selectuserContactInfo:USERCONTACT_TABLE andkeyValue:model andkeyArray:valueArray];
            
        }
        
    }
    else if (codeNum == CODE_ERROE){
        [self repeatLogin:^(BOOL flag) {
            if (flag) {
                [self getGroupMemberInfo];
            }
            else{
                return;
            }
            
        }];
    }
}
- (void)repeatLogin:(IsRepeatLoginBlock)repeatBlock{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:LOG_USER_NAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:LOG_USER_PSW];
    NSDictionary *parameters = @{@"username":userName,@"password":passWord};
    [AFRequestService responseData:USER_LOGING_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        BOOL flag = [self getUserIfo:dict];
        // block返回是否请求成功
        repeatBlock(flag);
    }];
}
//sid失效后解析登入数据
- (BOOL)getUserIfo:(NSDictionary *)userIfo
{
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        NSDictionary *userDetail = [userIfo objectForKey:@"user"];
        //存储登入信息
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        // 获取并存储userId
        [user setObject:[NSString _859ToUTF8:[userDetail objectForKey:@"userId"]] forKey:U_ID];
        // 获取并存储sid
        [user setObject:[NSString _859ToUTF8:[userDetail objectForKey:@"sid"]] forKey:ACCESS_TOKEN_K];
        [user synchronize];
        
        // 把tocken写到服务器
        if ([[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] != nil && ![[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] isEqual:[NSNull null]]) {
            NSDictionary *params = @{@"userId": GET_USER_ID,@"sid":GET_S_ID,@"deviceToken":[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN]};
            [AFRequestService responseData:UPLOAD_TOCKEN_URL andparameters:params  andResponseData:^(NSData *responseData) {
            }];
        }
        return YES;
    }
    else if (codeNum == CODE_ERROE){
        return NO;
    }
    else{
        return NO;
    }
    
}
@end
