//
//  CommentView.h
//  UNITOA
//
//  Created by qidi on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interface.h"
#import "UserArticleList.h"
typedef void(^CommentViewBlock)(NSString *);
@interface CommentView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)NSMutableArray *goodArray;
@property(nonatomic, strong)UserArticleList *articleModel;
@property (nonatomic, copy)CommentViewBlock blockAction;
@property (nonatomic, strong) UICollectionView *collectionView;//使用UICollectionView进行布局
@end
