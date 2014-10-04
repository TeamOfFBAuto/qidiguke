//
//  TDDetailCell.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyListModel.h"
#import "VoicePlayCenter.h"

@interface TDDetailCell : UITableViewCell<VoicePlayCenterDelegate>
{
    VoicePlayCenter * voicePlayCenter;
    NSString * voice_url;
}


@property (strong, nonatomic) IBOutlet UIImageView *header_imageView;

@property (strong, nonatomic) IBOutlet UILabel *userName_label;

@property (strong, nonatomic) IBOutlet UIImageView *background_imageView;

@property (strong, nonatomic) IBOutlet UILabel *date_label;
///评论内容
@property(nonatomic,strong)UILabel * content_label;
///评论图片
@property(nonatomic,strong)UIImageView * content_imageView;
///语音评论
@property(nonatomic,strong)UIImageView * voice_imageView;
///语音评论时间
@property(nonatomic,strong)UILabel * voice_lenght_label;
@property(nonatomic,strong)NSMutableArray * voive_array;

///判断是否正在播放
@property(nonatomic,assign)BOOL isAnimationVoice;

-(void)setInfoWith:(ReplyListModel *)info;



@end
