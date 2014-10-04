//
//  SqliteFieldAndTable.h
//  UNITOA
//
//  Created by qidi on 14-7-23.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IsRepeatLoginBlock)(BOOL flag) ;
@interface SqliteFieldAndTable : NSObject
@property(nonatomic,copy)IsRepeatLoginBlock repeatBlock;
// 得到用户数据
- (void)getAllInfo;
// 得到用户数据
- (void)getUserInfo;
// 得到群组信息
- (void)getGroupInfo;
// 得到群组用户信息
- (void)getGroupMemberInfo;
// 用户个人信息
- (BOOL)getFeildandValue:(NSDictionary *)userIfo;
// 通过id获取个人信息
- (void)getFeildandValueById:(NSDictionary *)userIfo;
// 群信息
- (BOOL)getGroupFeildandValue:(NSDictionary *)userIfo;
- (void)getReturnAddGroup:(NSDictionary *)userIfo;
//群组成员信息
- (BOOL)getGroupMememberFeildandValue:(NSDictionary *)groupMemberIfo;
// 用户群组及联系人信息
- (void)getUserContactFeildandValue:(NSDictionary *)userContactIfo;
- (void)repeatLogin:(IsRepeatLoginBlock)repeatBlock;




@end
