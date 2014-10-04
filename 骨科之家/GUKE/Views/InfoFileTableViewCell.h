//
//  InfoFileTableViewCell.h
//  GUKE
//
//  Created by ianMac on 14-9-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^InfoFileTableViewCellBloc)(NSString *playfilepath);

@protocol InfoFileTableViewCellDelegate <NSObject>

-(void)playVideWithString:(NSString *)thestrUrl;
@end

#import "VoicePlayCenter.h"


@interface InfoFileTableViewCell : UITableViewCell<VoicePlayCenterDelegate, UIActionSheetDelegate>
{
    // 图片文件图片
    UIImageView *_imgFileImage;
    
    // 播放声音
    VoicePlayCenter *voicePlayCenter;
    UIButton *_imageVoiceIcon;
    UIImageView *voiceImageView;
    NSArray *_voiceLeftImageArr;
    BOOL isAnimationVoice;
    
    // 视频文件图片
    UIImageView *_videoFileImage;
    
    // 文件类型
    UILabel *_fileTypeName;
    // 文件大小
    UILabel *_fileSize;
    
    // 图片放大遮罩视图
    UIView *background;
    UIImageView *imgSaveView;

    
}
@property (nonatomic, strong)NSDictionary *fileDic;

@property(nonatomic,copy)InfoFileTableViewCellBloc mybloc;

@property(nonatomic,assign)id<InfoFileTableViewCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thebloc:(InfoFileTableViewCellBloc)habloc;

@end
