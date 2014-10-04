//
//  LiuLanSectionView.h
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiuLanSectionView : UIView



@property (strong, nonatomic) IBOutlet UILabel *fenlei_label;

@property (strong, nonatomic) IBOutlet UILabel *date_label;


@property (strong, nonatomic) IBOutlet UILabel *userName_label;

@property (strong, nonatomic) IBOutlet UILabel *sex_label;




-(void)setContentWithFenLei:(NSString *)fenlei Date:(NSString *)aDate UserName:(NSString *)aUserName Sex:(NSString *)aSex;










@end
