//
//  CommentView.m
//  UNITOA
//
//  Created by qidi on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CommentView.h"
#import "CommentCollectionView.h"
#import "UIImageView+WebCache.h"
#import "contentAndGood.h"
static NSString * const CellIdentifier = @"cellection";
@implementation CommentView
- (void)dealloc
{
    self.collectionView = nil;
    self.goodArray = nil;
    self.articleModel = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        //左右Cell之间的间隔
        layout.minimumInteritemSpacing = 10;
        //上下Cell的间隔
        layout.minimumLineSpacing = 2;
        
        layout.itemSize = CGSizeMake(25, 25);
        //横向排列
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5,250,[SingleInstance customHeight:[_goodArray count] andcount:5 andsingleHeight:35.0]) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setShowsVerticalScrollIndicator:NO];
        [self.collectionView setScrollsToTop:NO];
        [self.collectionView setScrollEnabled:NO];
        [self.collectionView registerClass:[CommentCollectionView class] forCellWithReuseIdentifier:CellIdentifier];
        [self.collectionView setAlwaysBounceVertical:YES];
        [self addSubview:self.collectionView];
        layout = nil;
    }
    return self;
}
- (void)setGoodArray:(NSMutableArray *)goodArray
{
    _goodArray = nil;
    _goodArray = goodArray;
    self.collectionView.frame = CGRectMake(5, 5,250,[SingleInstance customHeight:[_goodArray count] andcount:5 andsingleHeight:35.0]);
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_goodArray count] + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentCollectionView * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        for(UIView *view in collectionCell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        collectionCell.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
        collectionCell.imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"userarticle_heart@2x" ofType:@"png"]];
        [collectionCell.contentView addSubview:collectionCell.imgView];
        collectionCell.imgView = nil;

    }
    else{
    if ([_goodArray count] > 0){
        contentAndGood *model = (contentAndGood *)(_goodArray[indexPath.row -1]);
        collectionCell.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [collectionCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.iconUrl]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait_ico@2x" ofType:@"png"]]];
        [collectionCell.contentView addSubview:collectionCell.imgView];
         collectionCell.imgView = nil;
        
    }
    else{
        return nil;
    }
        
    }
    return collectionCell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    else{
    contentAndGood *model = (contentAndGood *)self.goodArray[indexPath.row - 1];
    self.blockAction(model.userId);
    }
   // NSLog(@"%@",model.userId);
}


@end
