//
//  UserArticleList.h
//  UNITOA
//
//  Created by qidi on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserArticleList : NSObject
@property(nonatomic, strong)NSString *articleId; // 文章id
@property(nonatomic, strong)NSString *context; // 发表的内容
@property(nonatomic, strong)NSString *photo; // 发表的图片
@property(nonatomic, strong)NSString *createDate; // 创建的日期
@property(nonatomic, strong)NSString *isGood; //当前用户是否已经点赞
@property(nonatomic, strong)NSString *deleteFlag; // 是否有删除权限
@property(nonatomic, strong)NSString *isShare; // 是否分享，0：否，1：是
@property(nonatomic, strong)NSString *shareComment; // 分享链接时的评论
@property(nonatomic, strong)NSString *fromWeixin; // 分享来源；0：分享链接；1：分享微信；2：分享病历库；3：分享资料库
@property(nonatomic, strong)NSString *sourceId; // 来源资料库或者病历库id
@property(nonatomic, strong)NSString *imageWidth;
@property(nonatomic, strong)NSString *imageHeight;
@property(nonatomic, strong)NSString *shareUrl;
@property(nonatomic, strong)NSString *userId;// 用户id
@property(nonatomic, strong)NSString *username;// 用户名
@property(nonatomic, strong)NSMutableArray *commentArray;// 存放评论的内容
@property(nonatomic, strong)NSMutableArray *goodArray;// 存放点赞的数据
//@property(nonatomic, strong)NSString *shareUrl;
@property(nonatomic, strong)NSMutableArray *allCommentArray;
@property(nonatomic, strong)NSMutableArray *allGoodArray;
///多个文件
@property(nonatomic,strong)NSMutableArray * attachlistArray;// 存放附件
@property(nonatomic, strong)NSString *iconUrl;

@end
