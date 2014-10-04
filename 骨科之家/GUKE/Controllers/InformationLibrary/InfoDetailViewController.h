//
//  InfoDetailViewController.h
//  GUKE
//  资料库 详情页
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"
@interface InfoDetailViewController : UIViewController
// 自定义初始化方法(传入model值)
- (instancetype)initWithModel:(InformationModel *)model;
@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;


@end
