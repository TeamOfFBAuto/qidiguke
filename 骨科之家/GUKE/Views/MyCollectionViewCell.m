//
//  MyCollectionViewCell.m
//  StudyUICollectionView
//
//  Created by lanouhn on 14-1-9.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
         _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
        
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 45,50, 20)];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.font = [UIFont systemFontOfSize:12];
       
        [self addSubview:_imgView];
        [self addSubview:_lable];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
