//
//  VoicePlayCenter.h
//  VColleagueChat
//
//  Created by lqy on 5/6/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    Play_chat = 0,
    Play_other
}playVoice;
typedef void(^stopBlock)();
@class PlayerModel;
@protocol VoicePlayCenterDelegate;
@interface VoicePlayCenter : NSObject{
    id <VoicePlayCenterDelegate> _playDelegate;
}
@property (nonatomic,assign) id <VoicePlayCenterDelegate> playDelegate;
@property (nonatomic,assign)playVoice playType;
+ (VoicePlayCenter *)sharedEnglishVoice;
// 这儿使用 fid 回传判断并不是一种好得方式 如果后台返回得多条数据使用了同一个fid文件 那么就会乱掉 最好加一个 唯一得fid 判断 这个值才是 数据唯一性得判断值 而不用fid来判断
- (void)downloadPlayVoice:(PlayerModel *)fid;
//for hot list loacal voice
- (void)downloadPlayVoice:(PlayerModel *)fid withBoolLocal:(BOOL)islocal;
//stop
- (void)stopPlayer;
@property (nonatomic, copy)stopBlock block;
@end
@protocol VoicePlayCenterDelegate <NSObject>
@optional
- (void)stopPlayVoice:(PlayerModel *)fid;
- (void)startPlayVoice:(PlayerModel *)fid;
@end


@interface PlayerModel : NSObject
//文件fid
@property (nonatomic,retain) NSString *fileId;
//文件唯一标记 防止多处语音是同样fid的情况...导致ui界面混乱
@property (nonatomic,retain) NSString *infoId;


@property (nonatomic,retain) NSString *filename;//存储再本地的filename


@end


@interface FileCache : NSObject
+ (NSString *)voiceCacheKeyVoiceUrl:(NSString *)url;
@end
