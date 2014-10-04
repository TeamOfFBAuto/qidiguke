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
            model.address = [userInfo valueForKey:@"address"];
            model.allowPosition = [userInfo valueForKey:@"allowPosition"];
            model.articleBg = [userInfo valueForKey:@"articleBg"];
            model.bgUpdateTime = [userInfo valueForKey:@"bgUpdateTime"];
            model.chkATime = [userInfo valueForKey:@"chkATime"];
            model.cityName = [userInfo valueForKey:@"cityName"];
            model.companyId = [userInfo valueForKey:@"companyId"];
            model.createDate = [userInfo valueForKey:@"createDate"];
            model.deletePerm = [userInfo valueForKey:@"deletePerm"];
            model.district = [userInfo valueForKey:@"district"];
            model.email = [userInfo valueForKey:@"email"];
            model.firstname = [userInfo valueForKey:@"firstname"];
            model.firstnameen = [userInfo valueForKey:@"firstnameen"];
            model.icon = [userInfo valueForKey:@"icon"];
            model.iconUpdateTime = [userInfo valueForKey:@"iconUpdateTime"];
            model.inviteCodeId = [userInfo valueForKey:@"inviteCodeId"];
            model.invitePerm = [userInfo valueForKey:@"invitePerm"];
            model.itcode = [userInfo valueForKey:@"itcode"];
            model.lastChkETime = [userInfo valueForKey:@"lastChkETime"];
            model.lastLogin = [userInfo valueForKey:@"lastLogin"];
            model.lastLoginIP = [userInfo valueForKey:@"lastLoginIP"];
            model.latitude = [userInfo valueForKey:@"latitude"];
            model.loginCount = [userInfo valueForKey:@"loginCount"];
            model.longitude = [userInfo valueForKey:@"longitude"];
            model.mailStatus = [userInfo valueForKey:@"mailStatus"];
            model.memo = [userInfo valueForKey:@"memo"];
            model.mobile = [userInfo valueForKey:@"mobile"];
            model.organization = [userInfo valueForKey:@"organization"];
            model.organizationen = [userInfo valueForKey:@"organizationen"];
            model.parentCode = [userInfo valueForKey:@"parentCode"];
            model.parentId = [userInfo valueForKey:@"parentId"];
            model.position = [userInfo valueForKey:@"position"];
            model.positionen = [userInfo valueForKey:@"positionen"];
            model.province = [userInfo valueForKey:@"province"];
            model.sex = [userInfo valueForKey:@"sex"];
            model.showMobile = [userInfo valueForKey:@"showMobile"];
            model.sid = [userInfo valueForKey:@"sid"];
            model.status = [userInfo valueForKey:@"status"];
            model.street = [userInfo valueForKey:@"street"];
            model.street_number = [userInfo valueForKey:@"street_number"];
            model.sysAdmin = [userInfo valueForKey:@"sysAdmin"];
            model.telephone = [userInfo valueForKey:@"telephone"];
            model.userId = [userInfo valueForKey:@"userId"];
            model.userType = [userInfo valueForKey:@"userType"];
            model.username = [userInfo valueForKey:@"username"];
            model.versionName = [userInfo valueForKey:@"versionName"];
            model.isFriend = [userInfo valueForKey:@"isFriend"];
            
            
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
            model.address = [userList valueForKey:@"address"];
            model.allowPosition = [userList valueForKey:@"allowPosition"];
            model.articleBg = [userList valueForKey:@"articleBg"];
            model.bgUpdateTime = [userList valueForKey:@"bgUpdateTime"];
            model.chkATime = [userList valueForKey:@"chkATime"];
            model.cityName = [userList valueForKey:@"cityName"];
            model.companyId = [userList valueForKey:@"companyId"];
            model.createDate = [userList valueForKey:@"createDate"];
            model.deletePerm = [userList valueForKey:@"deletePerm"];
            model.district = [userList valueForKey:@"district"];
            model.email = [userList valueForKey:@"email"];
            model.firstname = [userList valueForKey:@"firstname"];
            model.firstnameen = [userList valueForKey:@"firstnameen"];
            model.icon = [userList valueForKey:@"icon"];
            model.iconUpdateTime = [userList valueForKey:@"iconUpdateTime"];
            model.inviteCodeId = [userList valueForKey:@"inviteCodeId"];
            model.invitePerm = [userList valueForKey:@"invitePerm"];
            model.itcode = [userList valueForKey:@"itcode"];
            model.lastChkETime = [userList valueForKey:@"lastChkETime"];
            model.lastLogin = [userList valueForKey:@"lastLogin"];
            model.lastLoginIP = [userList valueForKey:@"lastLoginIP"];
            model.latitude = [userList valueForKey:@"latitude"];
            model.loginCount = [userList valueForKey:@"loginCount"];
            model.longitude = [userList valueForKey:@"longitude"];
            model.mailStatus = [userList valueForKey:@"mailStatus"];
            model.memo = [userList valueForKey:@"memo"];
            model.mobile = [userList valueForKey:@"mobile"];
            model.organization = [userList valueForKey:@"organization"];
            model.organizationen = [userList valueForKey:@"organizationen"];
            model.parentCode = [userList valueForKey:@"parentCode"];
            model.parentId = [userList valueForKey:@"parentId"];
            model.position = [userList valueForKey:@"position"];
            model.positionen = [userList valueForKey:@"positionen"];
            model.province = [userList valueForKey:@"province"];
            model.sex = [userList valueForKey:@"sex"];
            model.showMobile = [userList valueForKey:@"showMobile"];
            model.sid = [userList valueForKey:@"sid"];
            model.status = [userList valueForKey:@"status"];
            model.street = [userList valueForKey:@"street"];
            model.street_number = [userList valueForKey:@"street_number"];
            model.sysAdmin = [userList valueForKey:@"sysAdmin"];
            model.telephone = [userList valueForKey:@"telephone"];
            model.userId = [userList valueForKey:@"userId"];
            model.userType = [userList valueForKey:@"userType"];
            model.username = [userList valueForKey:@"username"];
            model.versionName = [userList valueForKey:@"versionName"];
            model.isFriend = [userList valueForKey:@"isFriend"];
            
            
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
            model.addTime = [contactlist objectForKey:@"addTime"];
            model.createDate = [contactlist valueForKey:@"createDate"];
            model.creator = [contactlist objectForKey:@"creator"];
            model.creatorName = [contactlist objectForKey:@"creatorName"];
            model.denytalk = [contactlist objectForKey:@"denytalk"];
            model.groupId = [contactlist objectForKey:@"groupId"];
            model.groupName = [contactlist objectForKey:@"groupName"];
            model.groupType = [contactlist objectForKey:@"groupType"];
            model.isCreator = [contactlist objectForKey:@"isCreator"];
            model.latestMsg = [contactlist objectForKey:@"latestMsg"];
            model.latestMsgUser = [contactlist objectForKey:@"latestMsgUser"];
            model.latestMsgUserName = [contactlist objectForKey:@"latestMsgUserName"];
            model.membermemo = [contactlist objectForKey:@"membermemo"];
            model.memo = [contactlist objectForKey:@"memo"];
            
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
            model.addTime = [userIfo objectForKey:@"createDate"];// 加入时间标注为群组的创建时间
            model.createDate = [userIfo valueForKey:@"createDate"];
            model.creator = [userIfo objectForKey:@"creator"];
            model.creatorName = GET_U_NAME;// 创建者的用户名位当前用户名
            model.denytalk = [userIfo objectForKey:@"denytalk"];
            model.groupId = [userIfo objectForKey:@"groupId"];
            model.groupName = [userIfo objectForKey:@"groupName"];
            model.groupType = [userIfo objectForKey:@"groupType"];
            model.isCreator = @"1";
            model.latestMsg = [userIfo objectForKey:@"latestMsg"];
            model.latestMsgUser = [userIfo objectForKey:@"latestMsgUser"];
            model.latestMsgUserName = [userIfo objectForKey:@"latestMsgUserName"];
            model.membermemo = [userIfo objectForKey:@"membermemo"];
            model.memo = [userIfo objectForKey:@"memo"];
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
    model.addTime = [groupMemberIfo objectForKey:@"addTime"];
    model.denytalk = [groupMemberIfo objectForKey:@"denytalk"];
    model.isCreator = [groupMemberIfo objectForKey:@"isCreator"];
    model.firstname = [groupMemberIfo objectForKey:@"firstname"];
    model.membermemo = [groupMemberIfo objectForKey:@"membermemo"];
    model.userId = [groupMemberIfo objectForKey:@"userId"];
    model.username = [groupMemberIfo objectForKey:@"username"];
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
            model.contactId = [contactlist objectForKey:@"contactId"];
            model.contactName = [contactlist valueForKey:@"contactName"];
            model.contactType = [contactlist objectForKey:@"contactType"];
            model.contactUsername = [contactlist objectForKey:@"contactUsername"];
            model.createDate = [contactlist objectForKey:@"createDate"];
            model.creator = [contactlist objectForKey:@"creator"];
            model.creatorName = [contactlist objectForKey:@"creatorName"];
            model.creatorUsername = [contactlist objectForKey:@"creatorUsername"];
            model.groupType = [contactlist objectForKey:@"groupType"];
            model.lastMsg = [contactlist objectForKey:@"lastMsg"];
            model.lastMsgTime = [contactlist objectForKey:@"lastMsgTime"];
            model.lastMsgUser = [contactlist objectForKey:@"lastMsgUser"];
            model.lastMsgUserFirstname = [contactlist objectForKey:@"lastMsgUserFirstname"];
            model.lastMsgUserUsername = [contactlist objectForKey:@"lastMsgUserUsername"];
            model.memo = [contactlist objectForKey:@"memo"];
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
        [user setObject:[userDetail objectForKey:@"userId"] forKey:U_ID];
        // 获取并存储sid
        [user setObject:[userDetail objectForKey:@"sid"] forKey:ACCESS_TOKEN_K];
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
