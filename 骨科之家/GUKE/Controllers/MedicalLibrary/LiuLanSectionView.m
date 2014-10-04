//
//  LiuLanSectionView.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "LiuLanSectionView.h"

@implementation LiuLanSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)setContentWithFenLei:(NSString *)fenlei Date:(NSString *)aDate UserName:(NSString *)aUserName Sex:(NSString *)aSex
{
    self.fenlei_label.text = fenlei;
    self.date_label.text = aDate;
    self.userName_label.text = aUserName;
    self.sex_label.text = aSex;
}

@end
