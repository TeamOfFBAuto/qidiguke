//
//  FriendIfo.h
//  UNITOA
//
//  Created by qidi on 14-6-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendIfo : NSObject
@property(nonatomic, strong)NSString *createDate; // 添加时间
@property(nonatomic, strong)NSString *dstUserId;// 被添加好友
@property(nonatomic, strong)NSString *dstUser; // 被添人用户名
@property(nonatomic, strong)NSString *dstUserName; // 被添加姓名
@property(nonatomic, strong)NSString *friendId;
@property(nonatomic, strong)NSString *status;// 状态，0：未处理；1：已经通过；2：已经拒绝；3：已经删除
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *icon;
@end
