//
//  UserArticleList.m
//  UNITOA
//
//  Created by qidi on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserArticleList.h"

@implementation UserArticleList
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.commentArray = [[NSMutableArray alloc]init];
        self.goodArray = [[NSMutableArray alloc]init];
        self.allCommentArray = [[NSMutableArray alloc]init];
        self.allGoodArray = [[NSMutableArray alloc]init];
        self.attachlistArray = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
