//
//  VoicePlayCenter.m
//  VColleagueChat
//
//  Created by lqy on 5/6/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "VoicePlayCenter.h"
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "VoiceConverter.h"
#import "VoiceRecorderBaseVC.h"
#import "HttpRequsetFactory.h"
#import "CCMD5.h"
@interface VoicePlayCenter ()<AVAudioPlayerDelegate,AVAudioSessionDelegate>
@property (retain,nonatomic) NSOperationQueue *downQueue;
@property (retain, nonatomic)AVAudioPlayer *player;
@property (retain,nonatomic) PlayerModel *playerModel;
@property (retain,nonatomic) PlayerModel *playerWaitModel;
@end
@implementation VoicePlayCenter
static VoicePlayCenter *sharInstance;
+ (VoicePlayCenter *)sharedEnglishVoice
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharInstance = [[VoicePlayCenter alloc] init];
    });
    return sharInstance;
}
- (void)dealloc{
    
    self.player = nil;
    [self.downQueue cancelAllOperations];
    self.downQueue = nil;
    self.playerWaitModel = nil;
    self.playerModel = nil;
    [super dealloc];
}
- (id)init{
    self = [super init];
    if (self) {
        self.downQueue = [[[NSOperationQueue alloc] init] autorelease];
        self.downQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}

- (void)stopPlayer{
    [self.player stop];
    self.player = nil;
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(stopPlayVoice:)]) {
        [self.playDelegate stopPlayVoice:self.playerModel];
    }
    self.playerWaitModel = nil;
    self.playerModel = nil;
}

- (void)downloadPlayVoice:(PlayerModel *)fid withBoolLocal:(BOOL)islocal{
    
}
- (void)downloadPlayVoice:(PlayerModel *)fid{
    if (!fid) return;
    self.playerWaitModel = fid;
    //如果这个检测出不是需要停止当前播放（即当前播放是此次点击的，需要停止操作），那么执行如果没有本地数据，从网络数据获取，如果本地有数据直接播放本地数据
    if ([self playVoiceCheck]) {
        // 本地文件的缓存路径
        NSString *fidWav =[VoiceRecorderBaseVC getPathByFileName:[FileCache voiceCacheKeyVoiceUrl:fid.fileId] ofType:@"wav"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //不管是否本地 只根据文件名字查找 没有的话去网络端下载 也可能会没有 不管
        if ([fileManager fileExistsAtPath:fidWav]){// 如果本地文件存在，
            [self playerPreparePlay:NO];
        }else{// 若本地文件不存在
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.playerWaitModel.fileId) {
                [dic setValue:self.playerWaitModel.fileId forKey:@"f"];
            }
            ASIFormDataRequest *request = nil;
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",GLOBAL_URL_FILEGET,fid.fileId]]];
            
            [request setDelegate:self];
            request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:fid,@"fid", nil];
            [request setDidFailSelector:@selector(voiceRequestFail:)];
            [request setDidFinishSelector:@selector(voiceRequestFinish:)];
            [request setTimeOutSeconds:10];
            [self.downQueue addOperation:request];
        }
    }
}
- (void)voiceRequestFail:(ASIHTTPRequest *)request{
    [self showTishi];
}
- (void)voiceRequestFinish:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    int staCode = [request responseStatusCode];
    if (responseData){
        /*首先写入 下载的amr 文件 然后转成wav的格式*/
        PlayerModel *fid = [request.userInfo objectForKey:@"fid"];
        NSString *amrFid = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@%@",[FileCache voiceCacheKeyVoiceUrl:[fid fileId]],@"wavToAmr"] ofType:@"amr"];
        if (fid) {
            BOOL res = [responseData writeToFile:amrFid atomically:YES];
            int aa = [VoiceConverter amrToWav:amrFid wavSavePath:[VoiceRecorderBaseVC getPathByFileName:[FileCache voiceCacheKeyVoiceUrl:[fid fileId]] ofType:@"wav"]];
            
            if ([[fid fileId] isEqualToString:self.playerWaitModel.fileId]) {
                [self playerPreparePlay:NO];
            }
        }
    }
}
- (void)showTishi{
    
}

//可能是本地切换播放
- (BOOL)playVoiceCheck{
    BOOL executionPreparePlay = NO;
    if (self.player && self.player.playing) {
        //如果正在播放 那么 停止当前播放
        if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(stopPlayVoice:)]) {
            [self.playDelegate stopPlayVoice:self.playerModel];
        }
        if ([self.playerModel.fileId isEqualToString:self.playerWaitModel.fileId]) {
            [self.player stop];self.player = nil;
            self.playerModel = nil;self.playerWaitModel = nil;//如果是一直在播放的 那么停止当前播放的
        }else{
            //切换播放
            //            [self playerPreparePlay];
            [self.player stop]; self.player = nil;
            executionPreparePlay = YES;
        }
    }else{
        //        [self playerPreparePlay];
        executionPreparePlay = YES;
        
    }
    return executionPreparePlay;
}

- (void)playerPreparePlay:(BOOL)loacal{
    
    [self.player stop];self.player = nil;
    NSError *error;
    if (!loacal) {
        self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSURL alloc] initFileURLWithPath:[VoiceRecorderBaseVC getPathByFileName:[FileCache voiceCacheKeyVoiceUrl:self.playerWaitModel.fileId] ofType:@"wav"]] autorelease] error:&error] autorelease];
    }else{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.playerWaitModel.fileId ofType:nil]];
        self.player = [[[AVAudioPlayer alloc] initWithData:data error:&error] autorelease];
    }
    self.player.delegate = self;
    self.playerModel = self.playerWaitModel;
    [self.player prepareToPlay];
    [self.player play];
    self.player.volume = 1;
    self.playerWaitModel = nil;
    if (self.playerModel && self.player.playing) {
        if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(startPlayVoice:)]) {
            [self.playDelegate startPlayVoice:self.playerModel];
        }
    }
}
- (void)notiStop{
    
}
#pragma mark player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(stopPlayVoice:)]) {
        [self.playDelegate stopPlayVoice:self.playerModel];
    }
    [player stop];
    self.block();
    self.playerModel = nil;
    self.playerWaitModel = nil;
    self.player = nil;
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(stopPlayVoice:)]) {
        [self.playDelegate stopPlayVoice:self.playerModel];
    }
    [player stop];
    self.playerModel = nil;
    self.playerWaitModel = nil;
    self.player = nil;
}
@end
@implementation PlayerModel
@synthesize fileId = _fileId,infoId = _infoId;

- (void)dealloc{
    
    self.fileId = nil;
    self.filename = nil;
    self.infoId = nil;
    [super dealloc];
}


@end



@implementation FileCache

+ (NSString *)voiceCacheKeyVoiceUrl:(NSString *)url{
    if (url && [url isKindOfClass:[NSString class]]) {
        return [CCMD5 CCMDPathForKey:url];
    }
    return nil;
}

@end